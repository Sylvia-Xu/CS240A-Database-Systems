xquery version "1.0";

declare variable $employee-xml as xs:string := "v-emps.xml";
declare variable $department-xml as xs:string := "v-depts.xml";

declare variable $records := 
	element records
	{
		for $emp in doc($employee-xml)//employee
		let $deptno := $emp/deptno[.='d005']
		where $deptno
		return element employee
		{
			for $sal in $emp/salary
				where not ($sal/@tend < $deptno/@tstart or $sal/@tstart > $deptno/@tend)
				return $sal
		}
	};

declare variable $start_dates := 
	for $date in distinct-values($records/employee/salary/@tstart)
		order by $date
		return xs:date($date);

declare variable $end_dates :=
	for $date in distinct-values($records/employee/salary/@tend)
		order by $date
		return xs:date($date);

declare variable $dates :=
	for $date in distinct-values(($start_dates, $end_dates))
		order by $date
		return $date;

declare variable $max_salaries :=
	for $date in $dates
		let $sals := $records/employee/salary[@tstart <= $date and @tend > $date]
		return element max_salary
		{
			attribute date {$date},
			xs:float(max($sals))
		};

declare variable $coalesced_salaries :=
	for $sal at $idx in $max_salaries
		where ($idx = 1 or ($idx > 1 and $max_salaries[$idx - 1] != $sal))
		return $sal;

(:Temporal Max.   For the employees  in department d005,  find  the maximum of their salaries over time,  and print the history of such a maximum.:)

element max_salaries
{
	for $max_salary at $idx in $coalesced_salaries
		let $tend := $coalesced_salaries[$idx + 1]/@date
		where $idx < count($coalesced_salaries)
		return element max_salary
		{
			attribute tstart {$max_salary/@date},
			attribute tend {$tend},
			string(data($max_salary))
		}
}