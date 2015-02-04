cd vendor/Maven/target
mkdir convert
cp dependencies.jar convert
cd convert
unzip dependencies.jar
unzip classes.jar 
rm classes.jar
rm dependencies.jar
jar cf dependencies.jar *
mv dependencies.jar ..
rm -rf convert
