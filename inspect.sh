set -e
mkdir -p output
unzip -n input/N03-190101_GML.zip -d input

OLDIFS=$IFS;

# npx mapshaper \
#     input/N03-19_190101.shp \
#     -filter "!!N03_002" \
#     -dissolve N03_002 copy-fields=N03_002 \
#     -each "console.log(N03_002)" \
#     -simplify interval=5000 \
#     -o "output/test/N03_002.geojson"
# ls -lh "output/test/N03_002.geojson"

PREFECTURES="\
    青森県,tohoku/aomori \
    岩手県,tohoku/iwate \
    宮城県,tohoku/miyagi \
    秋田県,tohoku/akita \
    山形県,tohoku/yamagata \
    福島県,tohoku/fukushima \
    茨城県,kanto/ibaraki \
    栃木県,kanto/tochigi \
    群馬県,kanto/gunma \
    埼玉県,kanto/saitama \
    千葉県,kanto/chiba \
    東京都,kanto/tokyo \
    神奈川県,kanto/kanagawa \
    新潟県,chubu/niigata \
    富山県,chubu/toyama \
    石川県,chubu/ishikawa \
    福井県,chubu/fukui \
    山梨県,chubu/yamanashi \
    長野県,chubu/nagano \
    岐阜県,chubu/gifu \
    静岡県,chubu/shizuoka \
    愛知県,chubu/aichi \
    三重県,kinki/mie \
    滋賀県,kinki/shiga \
    京都府,kinki/kyoto \
    大阪府,kinki/osaka \
    兵庫県,kinki/hyogo \
    奈良県,kinki/nara \
    和歌山県,kinki/wakayama \
    鳥取県,chugoku/tottori \
    島根県,chugoku/shimane \
    岡山県,chugoku/okayama \
    広島県,chugoku/hiroshima \
    山口県,chugoku/yamaguchi \
    徳島県,shikoku/tokushima \
    香川県,shikoku/kagawa \
    愛媛県,shikoku/ehime \
    高知県,shikoku/kochi \
    福岡県,kyushu/fukuoka \
    佐賀県,kyushu/saga \
    長崎県,kyushu/nagasaki \
    熊本県,kyushu/kumamoto \
    大分県,kyushu/oita \
    宮崎県,kyushu/miyazaki \
    鹿児島県,kyushu/kagoshima \
    沖縄県,kyushu/okinawa"
for TUPLE in $PREFECTURES
do 
    IFS=','
    set -- $TUPLE
    echo "generating output/$2/index.geojson"
    npx mapshaper \
        input/N03-19_190101.shp \
        -quiet \
        -filter "N03_001 === '$1' && !!N03_003" \
        -dissolve N03_003 copy-fields=N03_003 \
        -each "console.log(N03_003)"
done
IFS=$OLDIFS


# SUBPREFECTURES="\
#     オホーツク総合振興局,hokkaido/hokkaido/okhotsk \
#     空知総合振興局,hokkaido/hokkaido/sorachi \
#     釧路総合振興局,hokkaido/hokkaido/kushiro \
#     後志総合振興局,hokkaido/hokkaido/shiribeshi \
#     根室振興局,hokkaido/hokkaido/nemuro \
#     宗谷総合振興局,hokkaido/hokkaido/soya \
#     十勝総合振興局,hokkaido/hokkaido/tokachi \
#     上川総合振興局,hokkaido/hokkaido/kamikawa \
#     石狩振興局,hokkaido/hokkaido/ishikari \
#     胆振総合振興局,hokkaido/hokkaido/iburi \
#     渡島総合振興局,hokkaido/hokkaido/oshima \
#     日高振興局,hokkaido/hokkaido/hidaka \
#     留萌振興局,hokkaido/hokkaido/rumoi \
#     檜山振興局,hokkaido/hokkaido/hiyama \
#     "
# for TUPLE in $SUBPREFECTURES
# do 
#     IFS=','
#     set -- $TUPLE
#     echo "generating output/$2/index.geojson"
#     npx mapshaper \
#         input/N03-19_190101.shp \
#         -filter "N03_002 === '$1'" \
#         -each "\city = !!N03_003 ? N03_003 : N03_004" \
#         -dissolve city copy-fields=city \
#         -rename-fields name=city \
#         -each "type =  name.slice(-1) === '郡' ? 'county' : 'city'" \
#         -simplify interval=500 \
#         -o "output/geo-json/$2/index.geojson"
#     ls -lh "output/geo-json/$2/index.geojson"
# done
# IFS=$OLDIFS