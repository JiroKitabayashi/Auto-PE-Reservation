# 実行ファイル

import requests
import bs4
from pprint import pprint
from secr import secrets


class ClassInfo:
    # 予約可能授業を取得する関数
    def get_resarvatable_class():
        response = requests.post(secrets.BASE_URL, data=secrets.data)
        
        response.encoding = response.apparent_encoding
        soup = bs4.BeautifulSoup(response.text, "html.parser")
        a = soup.find_all('a')
        mypage = requests.get(secrets.BASE_URL+a[-4].get("href"))
        soup = bs4.BeautifulSoup(mypage.text, "html.parser")
        b = soup.find_all('td')
        for i in b[2::8]:
            print(i.text)


ClassInfo.get_resarvatable_class()
# 8個あるtdの内の後ろから後ろから３つ目

# print(soup)

# page = top & uid = 71802767 & auth = 837b90b1d5a80940dfa307c5515e1961 & limit = 9999 & semester = 20190 & lang = ja
