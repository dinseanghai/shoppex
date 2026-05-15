import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("dev") {
            dimension = "flavor-type"
            applicationId = "com.shoppex.dev"
            resValue(type = "string", name = "app_name", value = "ShoppeX-Dev")
        }
        create("prod") {
            dimension = "flavor-type"
            applicationId = "com.shoppex.com"
            resValue(type = "string", name = "app_name", value = "ShoppeX")
        }
    }
}