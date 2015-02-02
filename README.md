
# Usage
## Android
### Setup Rubymotion

We must add some *.so files and other libs to the *.apk file. Therefor we must modify RubyMotion to add this files:

```
      cp ./RubyMotion/0001-add-suport-for-packing-raw-files-to-apk.patch /Library/RubyMotion/
      cd /Library/RubyMotion
      git apply --check 0001-add-suport-for-packing-raw-files-to-apk.patch
If Everything is ok:
      git apply 0001-add-suport-for-packing-raw-files-to-apk.patch
```
