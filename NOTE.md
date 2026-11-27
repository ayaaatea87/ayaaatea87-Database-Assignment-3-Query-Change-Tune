# TASK-6 : 

## Predicted operator : 
1- top >>> select top (15) 
2 - index scan 
3- hash match or nested loop >>> inner join 
4 - sort >>> order by desc
5- filter >>> Where 


نوع العملية الفعلية
Logical Operation	      الهدف المنطقي للعملية
Actual Number of Rows      	عدد الصفوف الفعلي  
Estimated Number of Rows   	عدد الصفوف المتوقع
Actual Execution Mode	  طريقة التنفيذ الفعلية
Estimated Operator Cost	التكلفة التقديرية للعملية  
Estimated I/O Cost	تكلفة القراءة المتوقعة
Estimated CPU Cost	تكلفة المعالجة المتوقعة

# sort : 
عدد الصفوف المتوقع 
Estimated Number of row for all Execution = 15

رقم الصفوف الفعلي اللي تم تنفيذ عمليات الترتيب عليه 
Actual Number of row for all Execution = 63

طريقة التنفيذ الفعلية والمتوقعه
physical operator = logical operator = Sort

الترتيب تم بطريقة 
orderBy = Expr1002 Descending

الوقت المتوقع للتنفيذ 
estimated cost  = 1.60979 (44%)

عملية الترتيب تمت فى الميموري 
memoryFraction = 1



# nested loop : 
عدد الصفوف المتوقع 
Estimated Number of row for all Execution = 15

رقم الصفوف الفعلي اللي تم تنفيذ عمليات الترتيب عليه 
Actual Number of row for all Execution = 63

طريقة التنفيذ الفعلية والمتوقعه
physical operator = nested loop
logical operator = inner join


الوقت المتوقع للتنفيذ 
estimated cost  = 0.0000251 (0%)



# scan cluster index : 
عدد الصفوف المتوقع 
Estimated Number of row for all Execution = 43531.7
Estimated Number of row read = 146800


رقم الصفوف الفعلي اللي تم قراءته    
Actual Number of row for all Execution = 50427
Actual Number of row read = 146800


طريقة التنفيذ الفعلية والمتوقعه
physical operator = Clustered Index Scan
logical operator = Clustered Index Scan

الوقت المتوقع للتنفيذ 
estimated cost  = 1.95654 (54%)


# top : 
عدد الصفوف المتوقع 
Estimated Number of row for all Execution = 15


رقم الصفوف الفعلي اللي تم قراءته    
Actual Number of row for all Execution = 15

طريقة التنفيذ الفعلية والمتوقعه
physical operator = top
logical operator = top

الوقت المتوقع للتنفيذ 
estimated cost  = 0% (0%)



## Parallelism (Gather Streams)
بتقسم الشغل على مجموعة workers-threads بالتوازي 

## Compute Scalar
مسئول عن تنفيذ العمليات الحسابية زي حساب remaining amount - urgent or not status



## 7-1 :
# problem : year and month for each value in column ويحسب scan  على الجدول كله استخدام الفانكشن بيعمل 

 logical reads  before = 1006
 logical read after : 13



 ## 7-2 :
# problem : DATEDIFF for each value in column ويحسب scan  على الجدول كله استخدام الفانكشن بيعمل 

 logical reads  before = 599
 logical read after : 76



## 7-3 :
# problem :LEFT() for each value in column ويحسب scan  على الجدول كله استخدام الفانكشن بيعمل 

 logical reads  before =  1267
 logical read after : 20

 ## 7-4 :
# problem : idعملية حسابية على ال 

 logical reads  before =  128251
 logical read after : 4

 ## 7-5 :
# problem : different data type varchar ...Nvarchar

 logical reads  before =  725
 logical read after : 3

 ## 7-6 :
# problem :upper() for each value in column ويحسب scan  على الجدول كله استخدام الفانكشن بيعمل 

 logical reads  before =  1009
 logical read after : 3

 ## 7-7 :
# problem : OR 
 logical reads  before =  1267
 logical read after : 18

 ## 7-8 :
# problem : عملية حسابية على كل ال column

 logical reads  before =  45
 logical read after : 19


## task 8 :
  الإحصائيات (Statistics) كانت قديمة، فـ SQL Server توقّع إن الاستعلام هيرجع 100 صف بس، لكن فعليًا رجع 300,000 صف. بالتالي خصص Memory قليلة لعملية الـ Sort، ولما الذاكرة ما كفتش لترتيب البيانات، اضطر يستخدم الـ TempDB على الديسك، وده اسمه Sort Spill وبيأثر على الأداء.

لما عملنا Update للـ Statistics باستخدام FULLSCAN، السيرفر قدر يقدّر عدد الصفوف بشكل صحيح، وده حل مشكلة الـ Underestimation. وبعد ما قللنا الأعمدة اللي بنرجعها، حجم البيانات اللي محتاجة تتعملها Sort قل، واختفى الـ Warning.

## task 9 :
استخدا م distinct على عمود مافيهوش اندكس  ده بيخلى الsql server يعمل  hash table 
علشان يجمع القيم المتكررة ويطلع قيمة واحدة فقط ... aggregate hash match

في طريقة تانية اسمها stream aggregate بتشتغل علي القيم المرتبة وتطلع من كل تكرار قيمة واحدة فقط 


** unique -primarykey - id على distinct تاني جزء استخدام
sql server اكتفى بقراءة البيانات فقط لانها بدون تكرار 
 
 ## task 10  :
 When to use Numbers:
- لما يكون عندنا Database مركزية
- لما نهتم بالأداء وحجم الـ Indexes
- لما نحتاج IDs صغيرة ومتسلسلة
When to use GUIDs:
- لما البيانات بتتولد من أنظمة مختلفة
- لما نحتاج IDs فريدة بدون الرجوع لقاعدة بيانات مركزية
- في الأنظمة الموزعة والـ Synchronization