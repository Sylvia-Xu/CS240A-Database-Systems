xquery version "1.0";

declare variable $employee-xml as xs:string := "v-emps.xml";
declare variable $department-xml as xs:string := "v-depts.xml";

(:Temporal Count.  Print the history  of  employee count for (i) each department:)
element department_count
{
	for $dept in doc($department-xml)//department
		let $deptnos := doc($employee-xml)//deptno[.=$dept/deptno]
		let $distinct_dates :=
				for $date in distinct-values(($deptnos/@tstart, $deptnos/@tend))
				order by $date
				return $date
		return element department
		{
			attribute deptno {data($dept/deptno)},
			attribute deptname {data($dept/deptname)},
			for $tstart at $idx in $distinct_dates 
				let $records := $deptnos[@tstart <= $tstart and $tstart < @tend],
					$tend := $distinct_dates[$idx+1]
				where $idx < count($distinct_dates)
				return element count
				{
					attribute tstart {$tstart},
					attribute tend {$tend},
					string(count($records))
				}
					
		}
}