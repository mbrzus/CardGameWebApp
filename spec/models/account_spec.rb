require 'spec_helper'
require 'rails_helper'

describe Account do
  let(:valid_account) { FactoryBot.build(:account, username: 'unique_username') }
  let(:invalid_account) { FactoryBot.build(:account) }

  before(:each) { @account = FactoryBot.create(:account) }
  describe 'creating a new account' do
    context 'when valid parameters are passed' do
      it 'should be valid' do
        expect(valid_account).to be_valid
      end
      it 'should assign a session token to the account' do
        expect(@account.session_token).to_not be_nil
      end
    end
    context 'when invalid parameters are passed' do
      it 'should be invalid' do
        expect(invalid_account).to_not be_valid
      end
    end
  end
end
