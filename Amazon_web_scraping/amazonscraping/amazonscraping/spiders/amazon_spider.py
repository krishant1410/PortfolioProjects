import scrapy
from ..items import AmazonscrapingItem
#from .. object import AmazonscrapingPipeline

class AmazonSpiderSpider(scrapy.Spider):
    name = 'amazon'
    page_number =2

    start_urls = ['https://www.amazon.com/s?k=comics&i=stripbooks&s=relevancerank&crid=2JKU4EXDL1F87&qid=1648082646&sprefix=comics%2Cstripbooks%2C77&ref=sr_st_relevancerank']

    def parse(self, response):
        items = AmazonscrapingItem()


        product_name = response.css('.a-size-base-plus::text').extract()
        product_author = response.css('.s-title-instructions-style .a-size-base').css('::text').extract()
        product_price = response.css('.a-price-whole::text').extract()
        product_imagelink = response.css('.s-image::attr(src)').extract() #or can use .getall()
        print(type(product_name))
        # print(product_name)
        # type(product_author)
        # type(product_price)
        # type(product_imagelink)

        items['product_name'] = product_name
        items['product_author'] = product_author
        items['product_price'] = product_price
        items['product_imagelink'] = product_imagelink
        # print(items['product_name'])
        # print(items['product_author'])
        # print(items['product_price'])
        # print(items['product_imagelink'])
        print(type(items))
        print(type(items['product_name']))


        yield items

        next_page = 'https://www.amazon.com/s?k=comics&i=stripbooks&s=relevancerank&page=' + str(AmazonSpiderSpider.page_number) +'&crid=2JKU4EXDL1F87&qid=1648082649&sprefix=comics%2Cstripbooks%2C77&ref=sr_pg_2'
        if AmazonSpiderSpider.page_number <= 50:
            AmazonSpiderSpider.page_number +=1
            yield response.follow(next_page, callback=self.parse)
