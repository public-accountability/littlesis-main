#!/usr/bin/env fish

function download_oli -a version_number
    echo "downloading version: $version_number"
    set url "https://github.com/public-accountability/oligrapher/archive/$version_number.tar.gz"
    set tmp_dir (mktemp -d)
    set oligrapher_tar $tmp_dir/oligrapher.tar.gz
    set oligrapher_js_file "oligrapher-$version_number.js"
    set oligrapher_source_map_file "oligrapher-$version_number.js.map"
    
    curl -sSL $url > $oligrapher_tar
    sh -c "cd $tmp_dir && tar -z -f $oligrapher_tar --strip-components=2 --wildcards -x '*build/oligrapher.js*'"

    cat $tmp_dir/oligrapher.js | sed "s/sourceMappingURL=oligrapher.js.map/sourceMappingURL=$oligrapher_source_map_file/" > $oligrapher_js_file
    cp $tmp_dir/oligrapher.js.map $oligrapher_source_map_file
    
    rm -rf $tmp_dir
end
