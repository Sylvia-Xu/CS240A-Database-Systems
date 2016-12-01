xquery version "1.0";

declare variable $employee-xml as xs:string := "v-emps.xml";
declare variable $department-xml as xs:string := "v-depts.xml";
declare variable $date := '1995-01-06';

declare function local:snapshot($elements as element()*) as element()*
{
	for $element in $elements
	   return element
	       	{node-name($element)}
		    {
		       $element/@*[name(.)!="tend" and name(.)!="tstart"],
		       data($element)
		    }
};

declare function local:getDept($deptnos as element()*) as element()*
{
	for $deptno in $deptnos
		let $deptname := doc("v-depts.xml")//department[deptno=$deptno]/deptname
		return element
		
		{node-name($deptno)}
		{
			$deptno/@*,
			attribute name {string($deptname)},
			$deptno
		}
};

(:Temporal Snapshot. Retrieve the name,  salary and department of  each employee who, on 1995-01-06 was making less than $44000.":)
element snapshot
{
	for $employee in doc($employee-xml)//employee[@tstart <= $date and $date <= @tend]
		let $salary := $employee/salary[@tstart <= $date and $date <= @tend],
			$deptno := $employee/deptno[@tstart <= $date and $date <= @tend]
		where($salary and $deptno and $salary < 44000)
		return element

		{node-name($employee)}
		{
			local:snapshot(($employee/firstname, $employee/lastname, local:getDept($deptno), $salary))
		}

}