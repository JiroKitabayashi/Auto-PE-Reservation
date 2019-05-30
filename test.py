import requests
import bs4
from pprint import pprint

ID = 's18276jk'
PASS = 'e980318Giraff'
TOP_PAGE_URL = 'https://wellness.sfc.keio.ac.jp/v3/index.php'

headers = {
    'Connection': 'keep-alive',
    'Pragma': 'no-cache',
    'Cache-Control': 'no-cache',
    'Origin': 'https://wellness.sfc.keio.ac.jp',
    'Upgrade-Insecure-Requests': '1',
    'Content-Type': 'application/x-www-form-urlencoded',
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.131 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3',
    'Referer': 'https://wellness.sfc.keio.ac.jp/v3/',
    'Accept-Encoding': 'gzip, deflate, br',
    'Accept-Language': 'ja,en-US;q=0.9,en;q=0.8',
}

data = {
    'login': ID,
    'password': PASS,
    'submit': 'login',
    'page': 'top',
    'mode': 'login',
    'semester': '20190',
    'lang': 'ja'
}

response = requests.post(
    TOP_PAGE_URL, data=data)
response.encoding = response.apparent_encoding
soup = bs4.BeautifulSoup(response.text, "html.parser")
a = soup.find_all('a')
mypage = requests.get(TOP_PAGE_URL+a[-4].get("href"))
soup = bs4.BeautifulSoup(mypage.text, "html.parser")
b = soup.find_all('td')
pprint(b[2].text)
# 8個あるtdの内の後ろから後ろから３つ目

# print(soup)

# page = top & uid = 71802767 & auth = 837b90b1d5a80940dfa307c5515e1961 & limit = 9999 & semester = 20190 & lang = ja
