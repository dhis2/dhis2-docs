import unittest
import markdown

class Tests(unittest.TestCase):

    def test_captions(self):
        md = markdown.Markdown(extensions=['markdown_captions'])

        # no caption img
        self.assertEqual(
            md.convert('![](foo.png)'),
            '<p><img alt="" src="foo.png" /></p>'
        )

        # captioned img
        self.assertEqual(
            md.convert('![caption](foo.png)'),
            '<p>\n<figure><img src="foo.png" /><figcaption>caption</figcaption>\n</figure>\n</p>'
        )

        # title
        self.assertEqual(
            md.convert('![caption](foo.png "title")'),
            '<p>\n<figure><img src="foo.png" title="title" /><figcaption>caption</figcaption>\n</figure>\n</p>'
        )

    def test_captions_attr(self):
        md = markdown.Markdown(extensions=['markdown_captions', 'attr_list'])

        # no caption img w/ attr_list
        self.assertEqual(
            md.convert('![](foo.png){: .class}'),
            '<p><img alt="" class="class" src="foo.png" /></p>'
        )

        # captioned img w/ attr_list
        self.assertEqual(
            md.convert('![caption](foo.png){: .class}'),
            '<p>\n<figure class="class"><img src="foo.png" /><figcaption>caption</figcaption></figure>\n</p>'
        )


if __name__ == '__main__':
    unittest.main()
