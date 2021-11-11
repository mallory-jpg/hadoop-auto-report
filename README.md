# Hadoop Auto Report
A MapReduce job to calculate and report the number of accidents per make & year of car, given the car's history.

## A Quick Hadoop Refresher

### How to Use
1. 

## 🚙🚙 The Data 🚙🚙
*Stored as a CSV in HDFS*
|Column   |Type   |Info |
|---|---|---|
|incident_id   |INT   |
|incident_type   |STRING   |I=inital sale, A=accident, R=repair|
|vin_number   |STRING   |   |
|make   |STRING   |Car brand: only populated by incident type 'I'   |
|model   |STRING   |Car model: only populated by incident type 'I'   |
|year   |STRING   |Car year: only populated by incident type 'I'   |
|incident_date   |DATE   |Date of incident occurence   |
|description   |STRING   |Type of repair ('R'), details of accident ('A'), or from where the car was sold ('I')   |

## The Job: Map, Then Reduce
1. `mapper1.py` takes in raw data from `stdin` ➡️ returns `vin_number`, (`incident_type`, `make`, `year`)
2. `reducer1.py` takes in `mapper1.py`'s output ➡️ returns all expected details of each unique set of vin_num + make + year that have incident types of 'A' (or accidents)
3. `mapper2.py` creates a composite key of make + year with a value of 1 for each incident count, for example `'Mercedes2015', 1`
4. `reducer2.py` compiles the incident count of each composite key to return the total count of each make & year with registered accidents (`incident_type` 'A')

### Testing
$ `cat hadoop_mini_data.csv | python mapper1.py | sort` yielded:
<img width="336" alt="Screen Shot 2021-11-11 at 5 14 43 PM" src="https://user-images.githubusercontent.com/65197541/141382287-727ca812-50a5-4fb5-a437-eea3cc22e4cd.png">

**Why use sort?**
Without using `sort` on the vin key (to mimic MapReduce's shuffle/sort functionality), `cat hadoop_mini_data.csv | python mapper1.py | python reducer1.py | python mapper2.py | python reducer2.py` returns an error:
<img width="746" alt="Screen Shot 2021-11-11 at 5 19 05 PM" src="https://user-images.githubusercontent.com/65197541/141382603-2ce0f5dc-17cd-4207-8a12-378ab122d96b.png">


$ `cat hadoop_mini_data.csv | python mapper1.py | sort | python reducer1.py` yielded:
<img width="310" alt="Screen Shot 2021-11-11 at 5 16 14 PM" src="https://user-images.githubusercontent.com/65197541/141382384-21b2bb64-afd8-4364-991d-cf2991f1c72d.png">

$ `cat hadoop_mini_data.csv | python mapper1.py | sort | python reducer1.py | python mapper2.py | sort ` yielded:
<img width="137" alt="Screen Shot 2021-11-11 at 5 17 46 PM" src="https://user-images.githubusercontent.com/65197541/141382500-954ff91a-089a-4927-b5d7-8b191ed3293a.png">


$ `cat hadoop_mini_data.csv | python mapper1.py | sort | python reducer1.py | python mapper2.py | sort | python reducer2.py` yielded:
<img width="162" alt="Screen Shot 2021-11-11 at 5 15 34 PM" src="https://user-images.githubusercontent.com/65197541/141382338-6df98a7b-6667-402e-b14a-db3d1bc2bf94.png">

