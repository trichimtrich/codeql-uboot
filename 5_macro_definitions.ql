import cpp

from Macro m
where m.getName().regexpMatch("ntoh.*")
select m, m.getName() + " found"