set -e
mkdir -p output
unzip -n input/N03-190101_GML.zip -d input
OLDIFS=$IFS;

# MAJOR_CITIES="\
#     札幌市,hokkaido/hokkaido/ishikari/sapporo \
#     仙台市,tohoku/miyagi/sendai \
#     さいたま市,kanto/saitama/saitama \
#     千葉市,kanto/chiba/chiba \
#     横浜市,kanto/kanagawa/yokohama \
#     川崎市,kanto/kanagawa/kawasaki \
#     相模原市,kanto/kanagawa/sagamihara \
#     新潟市,chubu/niigata/niigata \
#     静岡市,chubu/shizuoka/shizuoka \
#     浜松市,chubu/shizuoka/hamamatsu \
#     名古屋市,chubu/aichi/nagoya \
#     京都市,kinki/kyoto/kyoto \
#     大阪市,kinki/osaka/osaka \
#     堺市,kinki/osaka/sakai \
#     神戸市,kinki/hyogo/kobe \
#     岡山市,chugoku/okayama/okayama \
#     広島市,chugoku/hiroshima/hiroshima \
#     北九州市,kyushu/fukuoka/kitakyushu \
#     福岡市,kyushu/fukuoka/fukuoka \
#     熊本市,kyushu/kumamoto/kumamoto \
#     "
MAJOR_CITIES="\
    神戸市,kinki/hyogo/kobe \
    札幌市,hokkaido/hokkaido/ishikari/sapporo \
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
        -each "type = 'district', name=N03_004" \
        -o "output/test/$2/index.geojson"
    ls -lh "output/test/$2/index.geojson"
done
IFS=$OLDIFS