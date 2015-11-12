All these stats ignore class projects which are currently banned from creating batch experiments.

Recent activity:
	
	mysql>
	select year(last_activity) as yr, month(last_activity) as mo,
	       p.pid, eid
	  from experiment_stats s, projects p
	 where s.pid_idx = p.pid_idx and
	       !p.class and batch and year(last_activity) >= 2009
	 order by yr, mo, p.pid, eid;
	+------+------+--------------+---------------+
	| yr   | mo   | pid          | eid           |
	+------+------+--------------+---------------+
	| 2009 |    4 | T1T2         | jdemo         | 
	| 2009 |    5 | SecureIED    | 32hostsmcast  | 
	| 2010 |    1 | liveobjects2 | myexp1        | 
	| 2010 |    3 | DeterTest    | jjh-batch     | 
	| 2010 |    3 | DeterTest    | jjh-batchtest | 
	| 2010 |    3 | liveobjects2 | myexp         | 
	| 2010 |    3 | Panorama     | bitfuzz10-1   | 
	| 2010 |    8 | SOS          | appcomm       | 
	+------+------+--------------+---------------+
	

All batch, by project:
	
	mysql> 
	select p.pid, count(*)
	  from experiment_stats e, projects p
	 where e.pid_idx = p.pid_idx and
	       !p.class and e.batch
	 group by pid order by count(*) desc;
	+--------------+----------+
	| pid          | count(*) |
	+--------------+----------+
	| ddos         |     2412 | 
	| Fidran       |      134 | 
	| FloodWatch   |       48 | 
	| MONA         |       29 | 
	| worm         |       12 | 
	| emulab-ops   |       12 | 
	| NSUDDOS      |       11 | 
	| DeterTest    |       10 | 
	| psuworm      |        8 | 
	| SOS          |        6 | 
	| rsgc         |        4 | 
	| DIAMOND      |        3 | 
	| Deter        |        2 | 
	| liveobjects2 |        2 | 
	| SWOON        |        2 | 
	| vinci        |        1 | 
	| T1T2         |        1 | 
	| SecureIED    |        1 | 
	| DDoSImpact   |        1 | 
	| Panorama     |        1 | 
	| eWorm        |        1 | 
	+--------------+----------+
	

All activity, ever:
	
	mysql>
	select year(last_activity) as yr, month(last_activity) as mo,
	       count(*)
	  from experiment_stats s, projects p
	 where s.pid_idx = p.pid_idx and
	       !p.class and batch
	 group by yr, mo
	 order by yr, mo;
	
Note: y axis is log scale
[[Image(graph.png)]]