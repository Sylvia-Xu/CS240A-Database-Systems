xquery version "1.0";

declare variable $employee-xml as xs:string := "v-emps.xml";
declare variable $department-xml as xs:string := "v-depts.xml";

declare variable $start := '1994-05-01';
declare variable $end := '1996-05-06';

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

declare function local:slice($elements as element()*) as element()*
{
	for $element in $elements
		let $pstart :=  local:maxDate($element/@tstart, $start),
			$pend := local:minDate($element/@tend, $end)
		return element

		{node-name($element)}
		{
			attribute tstart {$pstart},
			attribute tend {$pend},
			$element/@*[name(.)!="tend" and name(.)!="tstart"],
			string($element)
		}
	
};

(:Temporal Slicing. For all departments, show their history in the period starting on 1994-05-01 and ending 1996-05-06.:)
element slice
{
	for $department in doc($department-xml)//department[not(@tstart > $end or @tend < $start)]
		return element

		{node-name($department)}
			{
				local:slice($department/*[not(@tstart > $end or @tend < $start)])
			}
}