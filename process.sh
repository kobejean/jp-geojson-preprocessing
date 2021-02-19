set -e
mkdir -p output
unzip -n input/N03-190101_GML.zip -d input
OLDIFS=$IFS;

REGIONS_MAP='{\
    北海道: "北海道", \
    \
    青森県: "東北", \
    岩手県: "東北", \
    宮城県: "東北", \
    秋田県: "東北", \
    山形県: "東北", \
    福島県: "東北", \
    \
    茨城県: "関東", \
    栃木県: "関東", \
    群馬県: "関東", \
    埼玉県: "関東", \
    千葉県: "関東", \
    東京都: "関東", \
    神奈川県: "関東", \
    \
    新潟県: "中部", \
    富山県: "中部", \
    石川県: "中部", \
    福井県: "中部", \
    山梨県: "中部", \
    長野県: "中部", \
    山梨県: "中部", \
    岐阜県: "中部", \
    静岡県: "中部", \
    愛知県: "中部", \
    \
    三重県: "近畿", \
    滋賀県: "近畿", \
    京都府: "近畿", \
    大阪府: "近畿", \
    兵庫県: "近畿", \
    奈良県: "近畿", \
    和歌山県: "近畿", \
    \
    鳥取県: "中国", \
    島根県: "中国", \
    岡山県: "中国", \
    広島県: "中国", \
    山口県: "中国", \
    \
    徳島県: "四国", \
    香川県: "四国", \
    愛媛県: "四国", \
    高知県: "四国", \
    \
    福岡県: "九州", \
    佐賀県: "九州", \
    長崎県: "九州", \
    熊本県: "九州", \
    大分県: "九州", \
    長崎県: "九州", \
    宮崎県: "九州", \
    鹿児島県: "九州", \
    沖縄県: "九州", \
}'

COMMON_PROPERTIES='\
    interiorPoint = { x: this.innerX, y: this.innerY }; \
    const [xMin, yMin, xMax, yMax] = this.bounds; \
    bounds = { xMin, yMin, xMax, yMax };'

# output/regions.geojson
npx mapshaper \
    input/N03-19_190101.shp \
    -each "region=${REGIONS_MAP}[N03_001]" \
    -dissolve region copy-fields=region  \
    -rename-fields id=region \
    -each "\
        type = 'region'; \
        $COMMON_PROPERTIES \
        " \
    -simplify interval=5000 \
    -o output/geo-json/index.geojson
ls -lh output/geo-json/index.geojson

# output/*/prefectures.geojson
REGIONS="\
    北海道,hokkaido \
    東北,tohoku \
    関東,kanto \
    中部,chubu \
    近畿,kinki \
    中国,chugoku \
    四国,shikoku \
    九州,kyushu"
for TUPLE in $REGIONS
do 
    IFS=','
    set -- $TUPLE
    echo "generating output/$2/index.geojson"
    npx mapshaper \
        input/N03-19_190101.shp \
        -filter "$REGIONS_MAP[N03_001] == '$1'" \
        -dissolve N03_001 copy-fields=N03_001 \
        -each "\
            type = 'prefecture', id=N03_001; \
            $COMMON_PROPERTIES \
            " \
        -simplify interval=1000 \
        -o "output/geo-json/$2/index.geojson"
    ls -lh "output/geo-json/$2/index.geojson"
done
IFS=$OLDIFS

LARGE_PREFECTURES="\
    北海道,hokkaido/hokkaido \
    "
for TUPLE in $LARGE_PREFECTURES
do 
    IFS=','
    set -- $TUPLE
    echo "generating output/$2/index.geojson"
    npx mapshaper \
        input/N03-19_190101.shp \
        -filter "N03_001 === '$1'" \
        -dissolve N03_002 copy-fields=N03_001,N03_002 \
        -each "\
            type = 'subprefecture', id=N03_002; \
            $COMMON_PROPERTIES \
            " \
        -simplify interval=1000 \
        -o "output/geo-json/$2/index.geojson"
    ls -lh "output/geo-json/$2/index.geojson"
done
IFS=$OLDIFS

# output/*/*/cities.geojson
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
        -filter "N03_001 === '$1'" \
        -each "\
            if (!!N03_003 && N03_003.slice(-1) !== '郡') {\
                city = N03_003;\
            } else {\
                city = N03_004;\
            }\
        " \
        -dissolve city copy-fields=city,N03_001,N03_002,N03_003,N03_004,N03_007 \
        -rename-fields id=city \
        -each "\
            type = id.slice(-1) === '区' ? 'district' : 'city'; \
            $COMMON_PROPERTIES \
            if (!!N03_003 && N03_003.slice(-1) !== '郡') {\
                delete N03_004;\
                delete N03_007;\
            }\
            " \
        -simplify interval=500 \
        -o "output/geo-json/$2/index.geojson"
    ls -lh "output/geo-json/$2/index.geojson"
done
IFS=$OLDIFS


SUBPREFECTURES="\
    オホーツク総合振興局,hokkaido/hokkaido/okhotsk \
    空知総合振興局,hokkaido/hokkaido/sorachi \
    釧路総合振興局,hokkaido/hokkaido/kushiro \
    後志総合振興局,hokkaido/hokkaido/shiribeshi \
    根室振興局,hokkaido/hokkaido/nemuro \
    宗谷総合振興局,hokkaido/hokkaido/soya \
    十勝総合振興局,hokkaido/hokkaido/tokachi \
    上川総合振興局,hokkaido/hokkaido/kamikawa \
    石狩振興局,hokkaido/hokkaido/ishikari \
    胆振総合振興局,hokkaido/hokkaido/iburi \
    渡島総合振興局,hokkaido/hokkaido/oshima \
    日高振興局,hokkaido/hokkaido/hidaka \
    留萌振興局,hokkaido/hokkaido/rumoi \
    檜山振興局,hokkaido/hokkaido/hiyama \
    "
for TUPLE in $SUBPREFECTURES
do 
    IFS=','
    set -- $TUPLE
    echo "generating output/$2/index.geojson"
    npx mapshaper \
        input/N03-19_190101.shp \
        -filter "N03_002 === '$1'" \
        -each "\
            if (!!N03_003 && N03_003.slice(-1) !== '郡') {\
                city = N03_003;\
            } else {\
                city = N03_004;\
            }\
        " \
        -dissolve city copy-fields=city,N03_001,N03_002,N03_003,N03_004,N03_007 \
        -rename-fields id=city \
        -each "\
            type = id.slice(-1) === '区' ? 'district' : 'city'; \
            $COMMON_PROPERTIES \
            if (!!N03_003 && N03_003.slice(-1) !== '郡') {\
                delete N03_004;\
                delete N03_007;\
            }\
            " \
        -simplify interval=500 \
        -o "output/geo-json/$2/index.geojson"
    ls -lh "output/geo-json/$2/index.geojson"
done
IFS=$OLDIFS

MAJOR_CITIES="\
    札幌市,hokkaido/hokkaido/ishikari/sapporo \
    仙台市,tohoku/miyagi/sendai \
    さいたま市,kanto/saitama/saitama \
    千葉市,kanto/chiba/chiba \
    横浜市,kanto/kanagawa/yokohama \
    川崎市,kanto/kanagawa/kawasaki \
    相模原市,kanto/kanagawa/sagamihara \
    新潟市,chubu/niigata/niigata \
    静岡市,chubu/shizuoka/shizuoka \
    浜松市,chubu/shizuoka/hamamatsu \
    名古屋市,chubu/aichi/nagoya \
    京都市,kinki/kyoto/kyoto \
    大阪市,kinki/osaka/osaka \
    堺市,kinki/osaka/sakai \
    神戸市,kinki/hyogo/kobe \
    岡山市,chugoku/okayama/okayama \
    広島市,chugoku/hiroshima/hiroshima \
    北九州市,kyushu/fukuoka/kitakyushu \
    福岡市,kyushu/fukuoka/fukuoka \
    熊本市,kyushu/kumamoto/kumamoto \
    "
for TUPLE in $MAJOR_CITIES
do 
    IFS=','
    set -- $TUPLE
    echo "generating output/$2/index.geojson"
    npx mapshaper \
        input/N03-19_190101.shp \
        -filter "N03_003 === '$1'" \
        -dissolve N03_004 copy-fields=N03_001,N03_002,N03_003,N03_004,N03_007 \
        -each "\
            type = 'district', id=N03_004; \
            $COMMON_PROPERTIES \
            " \
        -simplify interval=100 \
        -o "output/geo-json/$2/index.geojson"
    ls -lh "output/geo-json/$2/index.geojson"
done
IFS=$OLDIFS

node process.js