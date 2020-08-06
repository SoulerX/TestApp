target 'TestApp' do

pod "SDWebImage"

pod 'MJRefresh'

pod 'MJExtension'

pod 'FMDB'

pod 'YYModel'

pod 'AFNetworking'

end

post_install do |installer|
copy_pods_resources_path = "Pods/Target Support Files/Pods-TestApp/Pods-TestApp-resources.sh"
string_to_replace = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"'
assets_compile_with_app_icon_arguments = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${BUILD_DIR}/assetcatalog_generated_info.plist"'
text = File.read(copy_pods_resources_path)
new_contents = text.gsub(string_to_replace, assets_compile_with_app_icon_arguments)
File.open(copy_pods_resources_path, "w") {|file| file.puts new_contents }
end
