xquery version "1.0";

declare variable $employee-xml as xs:string := "v-emps.xml";
declare variable $department-xml as xs:string := "v-depts.xml";

(:Selection and Temporal Projection. Retrieve the employment history of employee "Anneke Preusig":)
element history
{
	for $employee in doc($employee-xml)//employee[firstname="Anneke" and lastname="Preusig"]
	return $employee//deptno
}