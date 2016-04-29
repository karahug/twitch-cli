require 'twitch_classes'

describe 'twitch_classes' do
    let(:page) {Page.new}
    
    describe '#dispatch commands' do
        describe '#subscriptions' do
            it 'calls live subscriptions' do
                expect(page).to receive(:subscriptions).and_return(nil)
                page.dispatch('subscriptions')
            end
        
        end
        describe '#top' do
            it 'calls top livestreams' do
                expect(page).to receive(:top).and_return(nil)
                page.dispatch('top')
            end
            it 'calls top games' do
                expect(page).to receive(:top).with('-g').and_return(nil)
                page.dispatch('top -g')
            end
        end
        
        describe '#search' do
            it 'searches games' do
                expect(page).to receive(:search).with('Street Fighter', '-g').and_return(nil)
                page.dispatch('search -g Street Fighter')
            end
            it 'searches livestreams' do
                expect(page).to receive(:search).with('Street Fighter', '-s').and_return(nil)
                page.dispatch('search -s Street Fighter')
            end
        end
        
        describe '#navigation' do
            it 'calls next' do
                expect(page).to receive(:next).and_return(nil)
                page.dispatch('next')
            end
            it 'calls prev' do
                expect(page).to receive(:prev).and_return(nil)
                page.dispatch('prev')
            end
            it 'calls view' do
                expect(page).to receive(:view).with('1').and_return(nil)
                page.dispatch('view 1')
            end
        end
    end
    
    describe "#functions" do
    end
end