class UIModule: Module {
    public override func setUp() -> Void {
        detonator.setElementClass("com.iconshot.detonator.ui.view", ViewElement.self)
        detonator.setElementClass("com.iconshot.detonator.ui.text", TextElement.self)
        detonator.setElementClass("com.iconshot.detonator.ui.input", InputElement.self)
        detonator.setElementClass("com.iconshot.detonator.ui.textarea", TextAreaElement.self)
        detonator.setElementClass("com.iconshot.detonator.ui.image", ImageElement.self)
        detonator.setElementClass("com.iconshot.detonator.ui.video", VideoElement.self)
        detonator.setElementClass("com.iconshot.detonator.ui.audio", AudioElement.self)
        detonator.setElementClass("com.iconshot.detonator.ui.verticalscrollview", VerticalScrollViewElement.self)
        detonator.setElementClass("com.iconshot.detonator.ui.horizontalscrollview", HorizontalScrollViewElement.self)
        detonator.setElementClass("com.iconshot.detonator.ui.safeareaview", SafeAreaViewElement.self)
        detonator.setElementClass("com.iconshot.detonator.ui.icon", IconElement.self)
        detonator.setElementClass("com.iconshot.detonator.ui.activityindicator", ActivityIndicatorElement.self)
    }
}
