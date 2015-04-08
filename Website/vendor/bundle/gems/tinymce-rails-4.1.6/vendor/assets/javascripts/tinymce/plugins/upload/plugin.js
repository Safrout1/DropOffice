tinymce.PluginManager.add('upload', function(editor, url) {
    // Add a button that opens a window
    editor.addButton('upload', {
        text: 'Upload',
        icon: false,
        onclick: function() {
            // Open window
            editor.windowManager.open({
                title: 'Upload',
                buttons: [{
                    text: 'Close',
                    onclick: 'close'
                }],
                body: [
                    {type: 'textbox', name: 'path', label: 'Write your path:'}
                ],
                onsubmit: function(e) {
                    // Insert content when the window form is submitted
                    var x = editor.getContent();
                    editor.insertContent('Title: ' + e.data.title);
                }
            });
        }
    });

    // Adds a menu item to the tools menu
    editor.addMenuItem('upload', {
        text: 'Upload to your Dropbox',
        context: 'file',
        onclick: function() {
            // Open window
            editor.windowManager.open({
                title: 'Upload',
                buttons: [{
                    text: 'Close',
                    onclick: 'close'
                }],
                body: [
                    {type: 'textbox', name: 'title', label: 'Title'}
                ],
                onsubmit: function(e) {
                    // Insert content when the window form is submitted
                    editor.insertContent('Title: ' + e.data.title);
                }
            });
        }
        
    });
});