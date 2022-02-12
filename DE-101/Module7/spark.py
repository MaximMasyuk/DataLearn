from pyspark.sql import SparkSession, DataFrame
import pyspark.sql.functions as F


def extract_data(spark: SparkSession) -> DataFrame:
    path = "data/flights.csv"
    path1 = 'data/airports.csv'
    path3 = 'data/airlines.csv'
    dataF = [spark.read.option("header", "true").csv(path), 
             spark.read.option("header", "true").csv(path1), 
             spark.read.option("header", "true").csv(path3) ]
    return dataF





def divert_flights(df1: DataFrame , df2: DataFrame) -> DataFrame:

    df = df1.join(df2,df1.DESTINATION_AIRPORT == df2.IATA_CODE,how='left')
    output = (
        df.filter(F.col('DIVERTED') == 1)
        .filter(F.col('COUNTRY') == 'USA')
        .groupBy("AIRPORT")
        .agg(F.count("DIVERTED"))
        .orderBy(F.count("DIVERTED"), ascending=False)
        .show(5)
        
    )

    return output


def  canceled_flights(df1: DataFrame , df2: DataFrame) -> DataFrame:
    ddf1 = df1.withColumnRenamed("AIRLINE", "IATA_CODE")
    
    df = ddf1.join(df2,ddf1.IATA_CODE == df2.IATA_CODE,how='left')
    
    output = (
        df.filter(F.col('CANCELLED') == 1)
        .groupBy('AIRLINE')
        .agg(F.count("CANCELLED"))
        .orderBy(F.count("CANCELLED"), ascending=False).show(3))
        

    return output


def avg_time(df1: DataFrame , df2: DataFrame) -> DataFrame:

    df = df1.join(df2,df1.ORIGIN_AIRPORT == df2.IATA_CODE,how='left')

    output = (
        df.filter(F.col('COUNTRY') == 'USA')
        .groupBy('STATE').agg(F.avg('SCHEDULED_TIME')).orderBy(F.avg('SCHEDULED_TIME'), ascending=False).show(5)
    )

    return output



def main():
    
    spark = SparkSession.builder.appName("sparkDL").getOrCreate()

    dfs = extract_data(spark)
    dfflies = dfs[0]
    dfairports = dfs[1]
    dfairline = dfs[2]
    #canceled_flights(dfflies, dfairline)
    #divert_flights(dfflies,dfairports)
    avg_time(dfflies,dfairports)


    
    


main()