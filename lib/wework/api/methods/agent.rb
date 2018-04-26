require "erb"

module Wework
  module Api
    module Methods
      module Agent
        def authorize_url(redirect_uri, scope="snsapi_base", state="wxwork")
          # user agent: UA is mozilla/5.0 (iphone; cpu iphone os 10_2 like mac os x) applewebkit/602.3.12 (khtml, like gecko) mobile/14c92 wxwork/1.3.2 micromessenger/6.2
          uri = ERB::Util.url_encode(redirect_uri)
          "#{AUTHORIZE_ENDPOINT}?appid=#{corp_id}&redirect_uri=#{uri}&response_type=code&scope=#{scope}&agentid=#{agent_id}&state=#{state}#wechat_redirect"
        end

        def get_oauth_userinfo code
          get 'user/getuserinfo', params: {code: code}
        end

        def get_user_detail user_ticket
          post 'user/getuserdetail', {user_ticket: user_ticket}
        end

        def get_jssign_package url
          timestamp = Time.now.to_i
          noncestr = SecureRandom.hex(8)
          str = "jsapi_ticket=#{jsapi_ticket}&noncestr=#{noncestr}&timestamp=#{timestamp}&url=#{url}"
          {
            "appId"     => corp_id,
            "nonceStr"  => noncestr,
            "timestamp" => timestamp,
            "url"       => url,
            "signature" => Digest::SHA1.hexdigest(str),
            "rawString" => str
          }
        end

        def get_session_with_jscode(js_code, grant_type='authorization_code')
          get 'miniprogram/jscode2session', params: {js_code: js_code, grant_type: grant_type}
        end

        def get_agent
          get 'agent/get', params: {agentid: agent_id}
        end

        def set_agent data={}
          post 'agent/set', data.merge(agentid: agent_id)
        end

        def menu_create menu
          post 'menu/create', menu, params: {agentid: agent_id}
        end

        def menu_get
          get 'menu/get', params: {agentid: agent_id}
        end

        def menu_delete
          get 'menu/delete', params: {agentid: agent_id}
        end

        def text_message_send user_ids, department_ids, content
          message_send user_ids, department_ids, {text: {content: content}, msgtype: 'text'}
        end

        def image_message_send user_ids, department_ids, media_id
          message_send user_ids, department_ids, {image: {media_id: media_id}, msgtype: 'image'}
        end

        def voice_message_send user_ids, department_ids, media_id
          message_send user_ids, department_ids, {voice: {media_id: media_id}, msgtype: 'voice'}
        end

        def file_message_send user_ids, department_ids, media_id
          message_send user_ids, department_ids, {file: {media_id: media_id}, msgtype: 'file'}
        end

        def video_message_send user_ids, department_ids, video={}
          message_send user_ids, department_ids, {video: video, msgtype: 'video'}
        end

        def textcard_message_send user_ids, department_ids, textcard={}
          message_send user_ids, department_ids, {textcard: textcard, msgtype: 'textcard'}
        end

        def news_message_send user_ids, department_ids, news=[]
          message_send user_ids, department_ids, {news: {articles: news}, msgtype: 'news'}
        end

        def get_checkin_data start_time, end_time, userid_list=[], checkin_type=3
          # https://work.weixin.qq.com/api/doc#11196
          post 'checkin/getcheckindata', {
             opencheckindatatype: checkin_type,
             starttime: start_time,
             endtime: end_time,
             useridlist: userid_list,
          }
        end

        def get_approval_data start_time, end_time, next_spnum=nil
          # https://work.weixin.qq.com/api/doc#11228
          payload = {starttime: start_time, endtime: end_time}
          payload[:next_spnum] = next_spnum unless next_spnum.nil?
          post 'corp/getapprovaldata', payload
        end

        private

        def message_send user_ids, department_ids, payload={}
          payload[:agentid] = agent_id
          payload[:touser] = Array.wrap(user_ids).join('|') if user_ids.present?
          payload[:toparty] = Array.wrap(department_ids).join('|') if department_ids.present?

          post 'message/send', payload
        end
      end
    end
  end
end