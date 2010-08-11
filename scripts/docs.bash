# http://gauravj.com/blog/2009/06/setting-asdoc-description-for-packages/
echo "Run from the main directory of juicekit-flex-data to generate asdocs"
echo ""
echo "Output will be generated in target/asdoc-output/"
asdoc -doc-sources+=src/main/flex -external-library-path+=../juicekit-flex-core/bin/juicekit-flex-core.swc -package-description-file scripts/package-description-data.xml -main-title "JuiceKit Data API Documentation" -output target/asdoc-output/
open target/asdoc-output/index.html
