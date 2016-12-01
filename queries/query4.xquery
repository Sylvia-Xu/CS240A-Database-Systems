xquery version "1.0";

declare variable $employee-xml as xs:string := "v-emps.xml";
declare variable $department-xml as xs:string := "v-depts.xml";

declare variable $start := '1900-01-01';
declare variable $currentDate := xs:string(fn:adjust-date-to-timezone(current-date(), ()));

declare function local:validEndTime($date as xs:string) as xs:date
{
	if($date="9999-12-31")
	then xs:date($currentDate)
	else xs:date($date)	
};
declare function local:minDate($date1 as xs:string, $date2 as xs:string) as xs:date
{	
	if(xs:date($date1)<xs:date($date2))
	then xs:date($date1)
	else xs:date($date2)	
};

declare function local:maxDate($date1 as xs:string, $date2 as xs:string) as xs:date
{
	if(xs:date($date1)>xs:date($date2))
	then xs:date($date1)
	else xs:date($date2)
};

(:Duration: For each employee, show the longest period during which he/she went with no change in salary and his/her salary during that time.:)
element duration
{
	for $employee in doc($employee-xml)//employee
		let $durations := (for $salary in $employee/salary
							return local:validEndTime($salary/@tend) - xs:date($salary/@tstart))
		return element

		{node-name($employee)}
		{
			attribute tstart {local:maxDate($employee/@tstart, $start)},
			attribute tend {local:minDate($employee/@tend, $currentDate)},
			$employee/firstname,
			$employee/lastname,

			element LongestPeriod {max($durations)},
			for $salary in
				$employee/salary[local:validEndTime(@tend) - xs:date(@tstart)=max($durations)]
				order by $salary/@tstart, $salary/@tend
				return element
				{node-name($salary)}
				{
					attribute tstart {local:maxDate($employee/@tstart, $start)},
					attribute tend {local:minDate($employee/@tend, $currentDate)},
					string($salary)
				}
		}
}