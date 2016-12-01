xquery version "1.0";

declare variable $employee-xml as xs:string := "v-emps.xml";
declare variable $department-xml as xs:string := "v-depts.xml";

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

declare function local:getManager( $deptno as element() ) as element()*
{
	for $deptno in $deptno
		let $mgrnos := doc($department-xml)//department[deptno=$deptno]/mgrno
		
		for $mgrno in $mgrnos
			let $start := local:maxDate($mgrno/@tstart, $deptno/@tstart),
				$end := local:minDate($mgrno/@tend, $deptno/@tend)
			where not ($mgrno/@tend < $deptno/@tstart or $mgrno/@tstart > $deptno/@tend)

			return element manager {
				attribute tstart {$start},
				attribute tend {$end},
				attribute deptno {$deptno},
				string(data($mgrno))
			}
};

(:Temporal Join. For each employee show title history and  his/her manager history.:)
element temporalJoin
{
	for $emp in doc($employee-xml)//employee
		return element
		{node-name($emp)}
		{
			element empno {data($emp/empno)},
			element name {data($emp/firstname), data($emp/lastname)},
			element titles
			{
				for $title in $emp/title
				return element
				{node-name($title)}
				{
					attribute tstart {$title/@tstart},
					attribute tend {$title/@tend},
					string($title)
				}
			},
			element managers 
			{
				for $deptno in $emp/deptno
				return local:getManager($deptno)
			}
			
		}
}