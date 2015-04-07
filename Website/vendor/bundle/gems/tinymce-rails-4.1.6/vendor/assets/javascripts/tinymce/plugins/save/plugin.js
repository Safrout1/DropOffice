tinymce.PluginManager.add("save",function(a){
	function b(){
		var b;
		return b=tinymce.DOM.getParent(a.id,"form"),
		!a.getParam("save_enablewhendirty",!0)||a.isDirty()?(tinymce.triggerSave(),a.getParam("save_onsavecallback")?void(a.execCallback("save_onsavecallback",a)&&(a.startContent=tinymce.trim(a.getContent({format:"raw"})),a.nodeChanged())):void(b?(a.isNotDirty=!0,(!b.onsubmit||b.onsubmit())&&("function"==typeof b.submit?b.submit():a.windowManager.alert("Error: Form submit field collision.")),a.nodeChanged()):a.windowManager.alert("Error: No form element found."))):void 0
	}
	function c(){
		var b=tinymce.trim(a.startContent);
		return a.getParam("save_oncancelcallback")?void a.execCallback("save_oncancelcallback",a):(a.setContent(b),a.undoManager.clear(),void a.nodeChanged())
	}

	function d(){
		var b=this;
		a.on("nodeChange",function(){b.disabled(a.getParam("save_enablewhendirty",!0)&&!a.isDirty())})
	}
	a.addCommand("mceSave",b),
	a.addCommand("mceCancel",c),
	a.addButton("save",{icon:"save",text:"Save",cmd:"mceSave",disabled:!0,onPostRender:d}),
	a.addButton("cancel",{text:"Cancel",icon:!1,cmd:"mceCancel",disabled:!0,onPostRender:d}),
	a.addShortcut("ctrl+s","","mceSave")
});