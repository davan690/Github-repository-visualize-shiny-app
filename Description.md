This app is to browse user’s public repositories in R Language. The metadata about the repositories is available via [Google BigQuery](https://developers.google.com/bigquery/) as part of [githubarchive](http://www.githubarchive.org/) project


Following query was used to download the data corresponding to all the R user repositories – 

```
SELECT MIN(created_at) as start_dt,
MAX(created_at) as end_dt,
repository_url, COUNT(repository_url) as num_stars,
MAX(repository_forks) as repository_forks_max,
MAX(repository_watchers) as repository_watchers,
repository_description, repository_name, 
repository_has_wiki,
repository_has_issues,
repository_fork,
max(repository_open_issues) as repository_open_issues_max,
max(repository_size) as repository_size_max,
repository_created_at
from githubarchive:github.timeline
where repository_language = 'R' and
type = 'WatchEvent' 
GROUP BY repository_url,
repository_description, 
repository_name, 
repository_created_at,
repository_has_wiki,
repository_has_issues,
repository_fork;
```
User can vary different inputs to select the subset of the data they want to browse. 


