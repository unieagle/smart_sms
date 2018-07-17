# encoding: utf-8
require 'spec_helper'

describe 'SmartSMS::HasSmsVerification' do
  let(:phone) { '13764071479' }
  let(:user) { User.create phone: phone }
  let(:account) { Account.create mobile: phone }

  context '#verify!' do
    let(:verification_code) { SmartSMS::VerificationCode.simple }

    describe 'Model User with default columns' do
      before do
        3.times { user.deliver_fake_sms }
        user.deliver_fake_sms verification_code
      end

      context 'with correct verification_code' do
        before { user.verify! verification_code }

        it 'should be verified' do
          expect(user.verify! verification_code).to be_truthy
          expect(user.reload.verified?).to be_truthy
        end

        it 'should have right verification code' do
          expect(user.latest_message.code).to eq verification_code
        end

        it 'should have 4 messages' do
          expect(user.messages.count).to eq 4
        end

        it 'should not be verified by using expired verification code' do
          user.verified_at = nil
          user.save
          expect(user.verify!(user.messages.first.code)).to be_nil
        end

        it 'should be the latest_message' do
          expect(user.latest_message).to eq user.messages.last
        end
      end

      context 'with incorrect verification_code' do
        before { user.verify! 'kfdsfd' }

        it 'should not be verified' do
          expect(user.verify!('kfdsfd')).to be_nil
          expect(user.reload.verified?).to be_falsey
        end

        it 'should not have right verification code' do
          expect(user.latest_message.code).not_to eq 'kfdsfd'
        end

        it 'should have 4 messages' do
          expect(user.messages.count).to eq 4
        end

        it 'should not be verified by using expired verification code' do
          user.verified_at = nil
          user.save
          expect(user.verify!(user.messages.first.code)).to be_nil
        end

        it 'should be the latest_message' do
          expect(user.latest_message).to eq user.messages.last
        end
      end
    end

    describe 'Model Account with custom columns' do
      before do
        3.times { account.deliver_fake_sms }
        account.deliver_fake_sms verification_code
      end

      context 'with correct verification_code' do
        before { account.verify! verification_code }

        it 'should be verified' do
          expect(account.verify! verification_code).to be_truthy
          expect(account.reload.verified?).to be_truthy
        end

        it 'should have right verification code' do
          expect(account.latest_message.code).to eq verification_code
        end

        it 'should have 4 messages' do
          expect(account.messages.count).to eq 4
        end

        it 'should not be verified by using expired verification code' do
          account.confirmed_at = nil
          account.save
          expect(account.verify!(account.messages.first.code)).to be_nil
        end

        it 'should be the latest_message' do
          expect(account.latest_message).to eq account.messages.last
        end

        it 'should be the same value for verified_at and confirmed_at' do
          expect(account.verified_at).to eq account.confirmed_at
        end
      end

      context 'with incorrect verification_code' do
        before { account.verify! 'kfdsfd' }

        it 'should not be verified' do
          expect(account.verify!('kfdsfd')).to be_nil
          expect(account.reload.verified?).to be_falsey
        end

        it 'should not have right verification code' do
          expect(account.latest_message.code).not_to eq 'kfdsfd'
        end

        it 'should have 4 messages' do
          expect(account.messages.count).to eq 4
        end

        it 'should not be verified by using expired verification code' do
          account.confirmed_at = nil
          account.save
          expect(account.verify!(account.messages.first.code)).to be_nil
        end

        it 'should be the latest_message' do
          expect(account.latest_message).to eq account.messages.last
        end

        it 'should be the same value for verified_at and confirmed_at' do
          expect(account.verified_at).to eq account.confirmed_at
        end
      end
    end
  end

  context '#verify' do
    let(:verification_code) { SmartSMS::VerificationCode.simple }

    describe 'Model User with default columns' do
      before do
        3.times { user.deliver_fake_sms }
        user.deliver_fake_sms verification_code
      end

      context 'with correct verification_code' do
        before { user.verify verification_code }

        it 'should be verified' do
          expect(user.verify verification_code).to be_truthy
          expect(user.reload.verified?).to be_falsey
        end

        it 'should have right verification code' do
          expect(user.latest_message.code).to eq verification_code
        end

        it 'should have 4 messages' do
          expect(user.messages.count).to eq 4
        end

        it 'should not be verified by using expired verification code' do
          user.verified_at = nil
          user.save
          expect(user.verify(user.messages.first.code)).to be_falsey
        end

        it 'should be the latest_message' do
          expect(user.latest_message).to eq user.messages.last
        end
      end

      context 'with incorrect verification_code' do
        before { user.verify 'kfdsfd' }

        it 'should not be verified' do
          expect(user.verify('kfdsfd')).to be_falsey
          expect(user.reload.verified?).to be_falsey
        end

        it 'should not have right verification code' do
          expect(user.latest_message.code).not_to eq 'kfdsfd'
        end

        it 'should have 4 messages' do
          expect(user.messages.count).to eq 4
        end

        it 'should not be verified by using expired verification code' do
          user.verified_at = nil
          user.save
          expect(user.verify(user.messages.first.code)).to be_falsey
        end

        it 'should be the latest_message' do
          expect(user.latest_message).to eq user.messages.last
        end
      end
    end

    describe 'Model Account with custom columns' do
      before do
        3.times { account.deliver_fake_sms }
        account.deliver_fake_sms verification_code
      end

      context 'with correct verification_code' do
        before { account.verify verification_code }

        it 'should be verified' do
          expect(account.verify verification_code).to be_truthy
          expect(account.reload.verified?).to be_falsey
        end

        it 'should have right verification code' do
          expect(account.latest_message.code).to eq verification_code
        end

        it 'should have 4 messages' do
          expect(account.messages.count).to eq 4
        end

        it 'should not be verified by using expired verification code' do
          account.confirmed_at = nil
          account.save
          expect(user.verify(account.messages.first.code)).to be_falsey
        end

        it 'should be the latest_message' do
          expect(account.latest_message).to eq account.messages.last
        end

        it 'should be the same value for verified_at and confirmed_at' do
          expect(account.verified_at).to eq account.confirmed_at
        end
      end

      context 'with incorrect verification_code' do
        before { account.verify 'kfdsfd' }

        it 'should not be verified' do
          expect(account.verify('kfdsfd')).to be_falsey
          expect(account.reload.verified?).to be_falsey
        end

        it 'should not have right verification code' do
          expect(account.latest_message.code).not_to eq 'kfdsfd'
        end

        it 'should have 4 messages' do
          expect(account.messages.count).to eq 4
        end

        it 'should not be verified by using expired verification code' do
          account.confirmed_at = nil
          account.save
          expect(account.verify(account.messages.first.code)).to be_falsey
        end

        it 'should be the latest_message' do
          expect(account.latest_message).to eq account.messages.last
        end

        it 'should be the same value for verified_at and confirmed_at' do
          expect(account.verified_at).to eq account.confirmed_at
        end
      end
    end
  end

  context '#deliver' do
    context 'deliver with options' do
      let(:url) { 'http://yunpian.com/v1/sms/tpl_send.json' }
      let(:options) do
        {
          tpl_id: 1234567,
          something: 8877654
        }
      end
      before do
        SmartSMS::VerificationCode.stub(:random).and_return("1234567890")
        SmartSMS.stub(:find_by_sid).and_return({
          'code' => 0,
          'msg'  => 'OK',
          'sms'  => {
            'sid'               => '592762800',
            'mobile'            => phone,
            'send_time'         => '2014-05-08 09:24:08',
            'text'              => 'some content',
            'send_status'       => 'SUCCESS',
            'report_status'     => 'SUCCESS',
            'fee'               => 1,
            'user_receive_time' => '2014-05-08 09:26:23',
            'error_msg'         => nil
          }
        })
        SmartSMS.stub(:deliver) do |number, text, opts|
          expect(number).to eq(phone)
          expect(text).to eq("1234567890")
          expect(opts).to eq(options)

          {
            'code' => 0,
            'msg'  => 'OK',
            'result' => {
              'count' => '1',
              'fee'   => '1',
              'sid'   => '592762800'
            }
          }
        end
      end

      it 'should send with options' do
        user.deliver nil, options
      end
    end
  end
end
