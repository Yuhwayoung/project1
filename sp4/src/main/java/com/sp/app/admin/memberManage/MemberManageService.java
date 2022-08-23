package com.sp.app.admin.memberManage;

import java.util.List;
import java.util.Map;

public interface MemberManageService {
	public int dataCount(Map<String, Object> map);
	public List<Member> listMember(Map<String, Object> map);
	
	public Member readMember(String userId);
	
	public List<Analysis> listAgeSection();
	
	public void updateFailureCountReset(String userId) throws Exception;
	public void updateMemberEnabled(Map<String, Object> map) throws Exception;
	public void insertMemberState(Member dto) throws Exception;
	public List<Member> listMemberState(String userId);
	public Member readMemberState(String userId);
	public void deleteMember(String userId, int membership) throws Exception;
	public void deletebbs(String userId, int membership) throws Exception;
	public void deletebbsLike(String userId, int membership) throws Exception;
	public void deletebbsReply(String userId, int membership) throws Exception;
	public void deletebbsReplyLike(String userId, int membership) throws Exception;
}
