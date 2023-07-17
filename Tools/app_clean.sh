if [ ! -d .gradle ]; then
cat << END
      Did not find .gradle subdirectory
      app_clean.sh must be run in app source directory
END
   exit
fi

rm -fr .gradle
rm -fr app/build
rm -fr app/.cxx
