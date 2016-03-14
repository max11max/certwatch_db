/* certwatch_db - Database schema
 * Written by Rob Stradling
 * Copyright (C) 2015-2016 COMODO CA Limited
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

CREATE OR REPLACE FUNCTION cablint(
	cert_data				certificate.CERTIFICATE%TYPE
) RETURNS SETOF cablint_issue.ISSUE_TEXT%TYPE
AS $$
DECLARE
	t_count			integer		:= 0;
	l_issue			RECORD;
BEGIN
	FOR l_issue IN (SELECT cablint_embedded(cert_data) CABLINT) LOOP
		t_count := t_count + 1;
		RETURN NEXT l_issue.CABLINT;
	END LOOP;

	IF t_count = 0 THEN
		RETURN QUERY SELECT unnest(string_to_array(cablint_shell(cert_data), chr(10)));
	END IF;
END;
$$ LANGUAGE plpgsql STRICT;
