from mkdocs.plugins import BasePlugin


class EditUrlPlugin(BasePlugin):
    def on_page_context(self, context, page, config, **kwargs):
        page.edit_url = ""
        if 'edit_url' in page.meta:
            page.edit_url = page.meta['edit_url']
        return context
