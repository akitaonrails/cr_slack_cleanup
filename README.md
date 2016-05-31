# Crystal - Slack Clean Up

You have a free Slack account, so your have limited storage and you're getting warnings already. You can now just clean up old uploaded files with this tool.

## Installation

You can build the executable like this:

    crystal build src/cr_slack_cleanup.cr --release

## Usage

You can run this tool against your own Slack account like this:

    ./cr_slack_cleanup --domain=your_domain --token=aaaa-0000000000-0000000000-000000000-0000000000

## Development

TODO: There are no tests in this project, unfortunatelly. Because it's basically an external HTTP consumer we'd need something like VCR to make better tests.

I originally did an Elixir version that has a very high concurrency and therefore it's also a good candidate for a Crystal implementation using the new Channel feature.

You can check out the [original Elixir source code here](https://github.com/akitaonrails/slack_cleanup)

In a simple test to delete 9 images from my Slack account the Elixir version performed like this:

    0,38s user 0,14s system 17% cpu 2,919 total

Then I uploaded the same set of images again and ran the Crystal version and it performed like this:

    0,03s user 0,01s system 2% cpu 1,835 total

The Crystal version not only ran much faster (startup and execution time) but also used much less resources.

## Contributing

1. Fork it ( https://github.com/akitaonrails/cr_slack_cleanup/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [AkitaOnRails](https://github.com/akitaonrails) - creator, maintainer
