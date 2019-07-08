local UiUtil = class("UiUtil")

UiUtil.miniLoading = import(".components.MiniLoading").getInstance()
UiUtil.topTip = import(".components.TopTip").getInstance()
UiUtil.ScaleButton = import(".components.ScaleButton")
UiUtil.ProgressBar = import(".components.ProgressBar")
UiUtil.HeaderNode = import(".components.HeaderNode")
UiUtil.TouchHelper = import(".components.TouchHelper")
UiUtil.UIListView = import(".components.UIListView")
UiUtil.NumberImage = import(".components.NumberImage")
UiUtil.AvatarView = import(".components.AvatarView")
UiUtil.Window = import(".window.Window")
UiUtil.Dialog = import(".dialog.Dialog")

return UiUtil
