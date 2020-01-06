# Setting Up the Employees Sample Database

* Clone the original project from GitHub <https://github.com/datacharmer/test_db.git>.
* Rename the directory to employees.
* Create your own git repository and push the files to it.
* Rename the original [README.md](./README.md) to [README-original.md](./README-original.md)
* Add this README.md
* Delete the Sakila Test Database
* Run `mysql < employees.sql` to install the database.
* Run the test script: `./sql_test.sh 'mysql -uoofenloch -pFakePassword -P3307'`

```bash
oofenloch@teben:~/workspaces/mysql$ git clone https://github.com/datacharmer/test_db.git
Cloning into 'test_db'...
remote: Enumerating objects: 105, done.
remote: Total 105 (delta 0), reused 0 (delta 0), pack-reused 105
Receiving objects: 100% (105/105), 74.27 MiB | 5.47 MiB/s, done.
Resolving deltas: 100% (54/54), done.
oofenloch@teben:~/workspaces/mysql$ mv test_db employees
oofenloch@teben:~/workspaces/mysql$ cd employees/
oofenloch@teben:~/workspaces/mysql/employees$ git status
On branch master
Your branch is up to date with 'origin/master'.

nothing to commit, working tree clean
oofenloch@teben:~/workspaces/mysql/employees$ git remote rename origin old-origin
oofenloch@teben:~/workspaces/mysql/employees$ git remote add origin https://teben.hopto.org:9080/mysql/employees.git
oofenloch@teben:~/workspaces/mysql/employees$ git push -u origin --all
Enumerating objects: 105, done.
Counting objects: 100% (105/105), done.
Delta compression using up to 8 threads
Compressing objects: 100% (50/50), done.
Writing objects: 100% (105/105), 74.27 MiB | 36.49 MiB/s, done.
Total 105 (delta 54), reused 105 (delta 54)
remote: Resolving deltas: 100% (54/54), done.
To https://teben.hopto.org:9080/mysql/employees.git
 * [new branch]      master -> master
Branch 'master' set up to track remote branch 'master' from 'origin'.
oofenloch@teben:~/workspaces/mysql/employees$ git push -u origin --tags
Everything up-to-date
oofenloch@teben:~/workspaces/mysql/employees$ git mv README.md README-original.md 
oofenloch@teben:~/workspaces/mysql/employees$ git rm -r sakila/
rm 'sakila/README.md'
rm 'sakila/sakila-mv-data.sql'
rm 'sakila/sakila-mv-schema.sql'
oofenloch@teben:~/workspaces/mysql/employees$ 
oofenloch@teben:~/workspaces/mysql/employees$ mysql `cat ~/.mysql/oofenloch@localhost` < employees.sql 
mysql: [Warning] Using a password on the command line interface can be insecure.
INFO
CREATING DATABASE STRUCTURE
INFO
storage engine: InnoDB
INFO
LOADING departments
INFO
LOADING employees
INFO
LOADING dept_emp
INFO
LOADING dept_manager
INFO
LOADING titles
INFO
LOADING salaries
data_load_time_diff
00:00:20
oofenloch@teben:~/workspaces/mysql/employees$
``