require 'spec_helper'

describe ExceptionNotifier::IdobataNotifier do
  let(:notifier) do
    described_class.new(
      :url => 'https://idobata.io/hook/endpoint',
      'Rails ENV' => 'staging'
    )
  end

  describe '#initialize' do
    it 'should set url' do
      expect(notifier.url).to eql('https://idobata.io/hook/endpoint')
    end
  end

  context 'option :skip_library_backtrace => true' do
    describe '#build_message' do
      let(:notifier) do
        ExceptionNotifier::IdobataNotifier.new(
          :url => 'https://idobata.io/hook/endpoint',
          :skip_library_backtrace => true,
        )
      end

      let(:library_trace) { 'gems/exception_notification-4.0.1/lib/exception_notifier.rb' }

      let(:exception) do
        StandardError.new('hello world').tap do |e|
          e.set_backtrace([
            [__FILE__,  __LINE__].join(':'),
            "#{Bundler.bundle_path + library_trace}:1"
          ])
        end
      end

      subject(:message) { notifier.send(:build_message, exception, {}) }

      specify { expect(message).not_to include(library_trace) }
    end
  end

  describe '#build_message' do
    let(:exception) { StandardError.new('hello, world') }
    let(:backtrace) { ['spec/exception_notifier/idobata_notifier_spec.rb'] }
    let(:enviroments) {
      {
        'URL'         => 'http://hrysd.org',
        'HTTP Method' => 'GET',
        'IP Address'  => '127.0.0.1',
        'Paramters'   => {'controller' => 'welcome', 'action' => 'index'},
        'Timestamp'   => "2014-03-16 16:30:35 +900"
      }
    }

    subject { notifier.send(:build_message, exception, enviroments) }

    before do
      allow(exception).to receive(:backtrace).and_return(backtrace)
    end

    it { expect(subject).to eql(<<-HTML) }
<span class='label label-important'>StandardError</span>
<b>&quot;hello, world&quot;</b>

<h4>Backtrace:</h4>
<pre>spec/exception_notifier/idobata_notifier_spec.rb</pre>

<h4>Environments:</h4>
<table>
  <tbody>
    <tr><th>Rails ENV</th><td>staging</td></tr><tr><th>URL</th><td>http://hrysd.org</td></tr><tr><th>HTTP Method</th><td>GET</td></tr><tr><th>IP Address</th><td>127.0.0.1</td></tr><tr><th>Paramters</th><td>{"controller"=>"welcome", "action"=>"index"}</td></tr><tr><th>Timestamp</th><td>2014-03-16 16:30:35 +900</td></tr>
  </tbody>
</table>
    HTML
  end
end
