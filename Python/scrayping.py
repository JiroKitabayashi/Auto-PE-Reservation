import requests
import bs4
BASE_URL = 'https://wellness.sfc.keio.ac.jp/v3/'  # 体育予約システム トップページ
USER_NAME = 's18276jk'
PASS = 'e980318Giraff'


def main():
    getJoinableClasses()
    pass


def getJoinableClasses():
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
        'login': 's18276jk',
        'password': 'e980318Giraff',
        'submit': 'login',
        'page': 'top',
        'mode': 'login',
        'semester': '20190',
        'lang': 'ja'
    }

    response = requests.post(
        'https://wellness.sfc.keio.ac.jp/v3/index.php', headers=headers, data=data)

    print(response)
    response.encoding = response.apparent_encoding
    soup = bs4.BeautifulSoup(response.text, "html.parser")
    # # ログイン
    reservation_tbody = soup.find("tbody")
    reservation_trs = reservation_tbody.find_all('tr')
    for i in reservation_trs:
        tds = i.find_all("td")
        print(tds[0])
        for i in tds:
            class_time = i.text
            # class_name = i[2].text
            # capacity = i[5].text
            # class_url = i[6].get("href")
            # print(class_time, class_name, capacity, class_url)
            print(class_time)


if __name__ == '__main__':
    main()
