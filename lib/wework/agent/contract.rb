module Wework
  module Agent
    class Contract < Base

      def initialize(corp_id, corp_secret)
        super(corp_id, CONTRACT_APP_ID, corp_secret)
      end

      def user_create userid, name, mobile, department, data={}
        post 'user/create', data.merge(userid: userid, name: name, mobile: mobile, department: department)
      end

      def user_get userid
        get 'user/get', params: {userid: userid}
      end

      def user_update userid, data={}
        post 'user/update', data.merge(userid: userid)
      end

      def user_delete userid
        get 'user/delete', params: {userid: userid}
      end

      def user_batchdelete useridlist=[]
        post 'user/batchdelete', {useridlist: useridlist}
      end

      def user_simplelist department_id, fetch_child=0
        get 'user/simplelist', params: {department_id: department_id, fetch_child: fetch_child}
      end

      def user_list department_id, fetch_child=0
        get 'user/list', params: {department_id: department_id, fetch_child: fetch_child}
      end

      def department_create name, parentid=0, data={}
        post 'department/create', data.merge(name: name, parentid: parentid)
      end

      def department_update department_id, data={}
        post 'department/update', data.merge(id: department_id)
      end

      def department_delete department_id
        get 'department/delete', params: {id: department_id}
      end

      def department_list department_id=0
        get 'department/list', params: {id: department_id}
      end
    end
  end
end