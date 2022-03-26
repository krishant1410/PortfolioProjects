# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html


# useful for handling different item types with a single interface
from itemadapter import ItemAdapter

#Scraped data -> Item Containers -> Json/csv files
#scraped data -> Item containers -> Pipeline -> SQL/Mongo database

import sqlite3

class AmazonscrapingPipeline(object):

    def __init__(self): #If class is called it will run two methods automatically
        self.create_connection()
        self.create_table()

    def create_connection(self):
        self.conn = sqlite3.connect("amazonscraped.db")
        self.curr = self.conn.cursor()

    def create_table(self):
        self.curr.execute("""DROP TABLE IF EXISTS info_tb""")
        self.curr.execute("""create table info_tb(
                product_name text,
                product_author text,
                product_price text,
                product_imagelink text
                )""")


    def process_item(self, item, spider):
        self.store_db(item)
        print("Pipeline:" + item['product_name'][0])
        return item

    def store_db(self, item):
        a=0
        b=0
        c=0
        d=0

        # for a in range(len(item['product_name'])):
        #     self.curr.execute("""insert into info_tb(product_name) values(?)""",(
        #         (item['product_name'][a]),
        #     )) #question mark as we are taking values externally and not entering it manually
        #     a+=1
        #
        #     for b in range(len(item['product_author'])):
        #         self.curr.execute("""insert into info_tb(product_author) values(?)""", (
        #             (item['product_author'][b]),
        #         ))  # question mark as we are taking values externally and not entering it manually
        #         b += 1
        #
        #         for c in range(len(item['product_price'])):
        #             self.curr.execute("""insert into info_tb(product_price) values(?)""", (
        #                 (item['product_price'][c]),
        #             ))  # question mark as we are taking values externally and not entering it manually
        #             c += 1
        #
        #             for d in range(len(item['product_imagelink'])):
        #                 self.curr.execute("""insert into info_tb(product_imagelink) values(?)""", (
        #                     (item['product_imagelink'][d]),
        #                 ))  # question mark as we are taking values externally and not entering it manually
        #                 d += 1
        #                 continue
        #             continue
        #         continue


        # i = 0
        # for i in range(len(item)):
        #     for a in range(len(item['product_name'])):
        for i in range(len(item['product_name'])):
            self.curr.execute("""insert into info_tb values (?,?,?,?)""", (
                (item['product_name'][i]),
                (item['product_author'][i]),
                (item['product_price'][i]),
                (item['product_imagelink'][i])
            ))  # question mark as we are taking values externally and not entering it manually
            i += 1
        self.conn.commit() #used to make sure the changes made to the database are consistent