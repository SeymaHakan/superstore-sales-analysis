-- Superstore Sales Data Analysis
-- Dataset: Kaggle Superstore dataset
-- Tools: MySQL
-- This project includes data cleaning and exploratory data analysis (EDA)
-- to identify sales patterns, regional performance, and profit insights.
-- ----------------------------------------------------------------------------
-- Süpermarket Satış Verilerinin Analizi
-- Veri Kümesi: Kaggle Süpermarket veri kümesi
-- Araçlar: MySQL
-- Bu proje, satış modellerini, bölgesel performansı ve 
-- kar içgörülerini belirlemek için veri temizleme ve keşifsel veri analizi (EDA) içermektedir.
-- -----------------------------------------------------------------------------

select *
from samplesuperstore;

-- ÖNCE BAŞKA BİR TABLO OLUŞTURALIM.

CREATE TABLE  kopya_samplesuperstore   # tüm verileri kopyalacağız.
LIKE samplesuperstore ;

SELECT *
FROM  kopya_samplesuperstore ;   -- yeni tablo adımız (copy olan tablo) 

# -- tablo başlıkları geldi. şimdi verileri ekleyecğiz. = insert

INSERT kopya_samplesuperstore
select *
from samplesuperstore;

SELECT *
FROM  kopya_samplesuperstore ;

--  buraya kadar ; gerçek veri setini, kopyaladık ve şimdi kopyaladığımız veri seti üzerinde değişiklik yaparak ilerleyeceğiz

-- 1. REMOVE DUPLICATES: 1. adım YİNELENENLERİ KALDIRMAYA ÇALIŞMAK
-- yapacağımız ilk şey satır numarası gibi bir şey yapmak ve tüm bu sütunlarla eşleştirmek
-- ardından yinelenen olup olmadığına bakmak.
-- şimdi yinelenenleri belirleyelim.(satır numaraalrı yapmak)
-- row_number = atlama yapmadan sıralama yapmak için
-- over () = pencere fonks.
-- partition by = bölümlendirmek

SELECT *
FROM  kopya_samplesuperstore ;

SELECT 'ship_mode', segment, country, city, state, 'postal code', region, category, 'sub-category', sales, quantity, discount, profit, count(*)
FROM kopya_samplesuperstore
GROUP BY 'ship_mode', segment, country, city, state, 'postal code', region, category, 'sub-category', sales, quantity, discount, profit
HAVING COUNT(*) >= 1
order by count(*) asc;

SELECT *,
ROW_NUMBER() OVER
(PARTITION BY 'ship_mode', segment, country, city, state, 'postal code', region, category, 'sub-category', sales, quantity, discount, profit) AS row_num
from kopya_samplesuperstore
order by row_num asc;

SELECT *
from (
select *,
	ROW_NUMBER() OVER
	(PARTITION BY 'ship_mode', segment, country, city, state, 'postal code', region, category, 'sub-category', sales, quantity, discount, profit) AS row_num
	from kopya_samplesuperstore
	order by row_num asc
) t
where row_num > 1;


# 1 den büyük değerler  = yinelemelerin olduğu yerlerdir.
# bunlardan kurtulmak istiyoruz.
# bunların yinelenenler olduğunu doğruluyalım.

-- COOLUMNS İSİMLERİNİ DÜZENLEME

ALTER TABLE kopya_samplesuperstore
RENAME COLUMN `ship_mode` TO Ship_Mode;

ALTER TABLE kopya_samplesuperstore
RENAME COLUMN `postal_code` TO Postal_Code;

ALTER TABLE kopya_samplesuperstore
RENAME COLUMN `sub_category` TO Sub_Category;

Select *
from kopya_samplesuperstore;
-- ----------------------------------------------------

SELECT *
from (
select *,
	ROW_NUMBER() OVER
	(PARTITION BY 'Ship_Mode', segment, country, city, state, 'Postal_Code', region, category, 'Sub_Category', sales, quantity, discount, profit) AS row_num
	from kopya_samplesuperstore
	order by row_num asc
) t
where row_num > 1;


-- Aynı olan kayıtları gruplayıp kaç tane olduklarını görebilirsin:
SELECT Ship_Mode, Segment, Country, City, State, Postal_Code,
Region, Category, Sub_Category, Sales, Quantity, Discount, Profit,
COUNT(*) AS duplicate_count
FROM kopya_samplesuperstore
GROUP BY 
Ship_Mode, Segment, Country, City, State, `Postal_Code`,
Region, Category,Sub_Category, Sales, Quantity, Discount, Profit
HAVING COUNT(*) > 1;

-- Yani aynı satırdan kaç tane olduğunu görürsün.

-- Null değer kontrolü
SELECT *
FROM kopya_samplesuperstore
WHERE 
ship_mode IS NULL
OR segment IS NULL
OR country IS NULL
OR city IS NULL
OR state IS NULL
OR postal_code IS NULL
OR region IS NULL
OR category IS NULL
OR sub_category IS NULL
OR sales IS NULL
OR quantity IS NULL
OR discount IS NULL
OR profit IS NULL;
-- Null değer yok

-- Negatif profit kontrolü
SELECT *
FROM kopya_samplesuperstore
WHERE profit < 0;

--                             EDA (Exploratory Data Analysis)
-- toplam satış

select round(sum(sales), 2)
from kopya_samplesuperstore;

-- category bazlı satış
select category, round(sum(sales),2)
from kopya_samplesuperstore
group by category
order by sum(sales) desc;
-- Teknoloji kategorisi genel olarak en yüksek satışları üretiyor.

-- region bazlı satış
select region, round(sum(sales),2)
from kopya_samplesuperstore
group by region
order by sum(sales) desc;
-- Batı(West) bölgesi diğer bölgelere kıyasla en yüksek satış rakamlarını elde ediyor.

-- en çok satış yapılan şehir
select city, round(sum(sales),2)
from kopya_samplesuperstore
group by city
order by sum(sales) desc;
-- New York City, tüm şehirler arasında en yüksek toplam satış rakamına sahip.

-- en çok satış yapıan sub_ category - teknoloji kategorisinden telefon
select category, sub_category, round(sum(sales),2) as top_satış
from kopya_samplesuperstore
group by  category, sub_category
order by sum(sales) desc;
-- en çok satış yapılan sub-category teknoloji kategorisinden telefondur.

-- indirim ve ortalama kar
SELECT  Ship_Mode, discount, avg(profit)
FROM kopya_samplesuperstore
GROUP BY ship_mode, discount
ORDER BY ship_mode asc, avg(profit) desc;

-- hangi sınıf müşteriler hangi category ve alt kategoriden alış veriş yapıyor
select ship_mode, category, sub_category, sales
from kopya_samplesuperstore
group by ship_mode, category, sub_category, sales
order by ship_mode desc, sales desc;
-- ---------------------------------------------------------------------------------------------------
-- hangi ülkenin hangi bölgesi en çok karı hangi category den getiriyor
select country, city, region, category, round(max(profit),2) as max_kar
from kopya_samplesuperstore
group by country,city, region, category
order by max(profit) desc;
-- united stated, Lafayette şehrinin Central bölgesi, Teknoloji kategorisi max_karı veriyor

-- peki zararı
select country, city, region, category, round(min(profit),2) as min_kar
from kopya_samplesuperstore
group by country,city, region, category
order by min(profit) asc;
-- united stated - Lancaster şehrinin east bölgesi, Teknoloji kategorisi min_karı veriyor
-- -----------------------------------------------------------------------------------------------

-- en çok indirimin olduğu bölge ve category bakalım
select country, city, region, category, max(Discount), min(discount), round(avg(Discount),2)
from kopya_samplesuperstore
group by country,city, region, category
order by max(discount) desc, min(discount) asc; 
-- united statesin Bloomington şehriin central bölgesi office_supplies categorisi en çok indirim alan 

-- en çok hangi bölgeden kar elde ediliyor 
SELECT region,
ROUND(MAX(profit),2) AS max_kar,
ROUND(MIN(profit),2) AS min_kar,
ROUND(AVG(profit),2) AS avg_kar
FROM kopya_samplesuperstore
GROUP BY region
ORDER BY avg_kar DESC;

-- her claas ın ortalama toplam ve minimum  sales ve toplam kar  bakalım
select ship_mode, min(sales), round(avg(sales),2) as ort_satış, max(sales), round(sum(sales),2) as top_satış, round(avg(profit),2) as ort_kar
from kopya_samplesuperstore
group by ship_mode
order by avg(profit) desc;

select *
from kopya_samplesuperstore
;


