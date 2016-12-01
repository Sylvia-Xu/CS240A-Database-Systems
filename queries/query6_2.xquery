xquery version "1.0";

declare variable $employee-xml as xs:string := "v-emps.xml";
declare variable $department-xml as xs:string := "v-depts.xml";

declare variable $deptnos := doc($employee-xml)//deptno;

declare variable $tstart_dates :=  
	for $start in distinct-values( $deptnos/@tstart )
		order by $start 
		return xs:date( $start );

declare variable $tend_dates := 
	for $end in distinct-values( $deptnos/@tend )   
		order by $end
		return xs:date( $end );

declare variable $dates := 
	for $date in distinct-values( ($tstart_dates, $tend_dates) )
		order by $date
		return $date;

declare variable $counts :=
	for $tstart at $idx in $dates
		let $records := $deptnos[@tstart <= $tstart and $tstart < @tend]
		order by $tstart
		return element employee_num
		{
			attribute date {$tstart},
			string(count($records))
		};

declare variable $coalesced_counts :=
	for $record at $idx in $counts
		where ($idx=1 or ( $idx > 1 and $counts[$idx - 1] != $record ))
		return $record;

element employee_count_history
{
	for $record at $idx in $coalesced_counts
		let $tend := $coalesced_counts[$idx + 1]/@date
		where $idx < count($coalesced_counts)
		return element records
		{
			attribute tstart {$record/@date},
			attribute tend {$tend},
			string(data($record))
		}
}