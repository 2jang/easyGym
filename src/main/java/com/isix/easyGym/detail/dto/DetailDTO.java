package com.isix.easyGym.detail.dto;

import java.sql.Date;
import org.springframework.stereotype.Component;

@Component("detailDTO")
public class DetailDTO {
	private int detailNo;
	private Date detailDate;
	private String detailRoadAddress;
	private String detailBusinessName;
	private String detailBusinessEng;
	private String detailDailyTicket;
	private String detailMonthlyTicket;
	private String detailComment;
	private String detailServiceProgram;
	private String detailClassification;
	private String detailFreeService;
	private int detailMonthlyPrice;
	private String detailKoClassification;
	private String detailLatitude;
	private String detailLongitude;
	private String operatorNo;

	// ▼▼▼ 여기에 새 필드를 추가합니다 ▼▼▼
	/**
	 * 이미지 로딩 실패 시 대체할 랜덤 이미지의 웹 경로를 저장하는 필드입니다.
	 * 이 필드는 DB와 무관한, View를 위한 임시 데이터입니다.
	 */
	private String randomImagePath;

	// ▼▼▼ 새로 추가된 필드의 Getter와 Setter입니다 ▼▼▼
	public String getRandomImagePath() {
		return randomImagePath;
	}

	public void setRandomImagePath(String randomImagePath) {
		this.randomImagePath = randomImagePath;
	}
	// ▲▲▲ 여기까지 추가 ▲▲▲

	public String getOperatorNo() {
		return operatorNo;
	}

	public void setOperatorNo(String operatorNo) {
		this.operatorNo = operatorNo;
	}

	public String getDetailLatitude() {
		return detailLatitude;
	}

	public void setDetailLatitude(String detailLatitude) {
		this.detailLatitude = detailLatitude;
	}

	public String getDetailLongitude() {
		return detailLongitude;
	}

	public void setDetailLongitude(String detailLongitude) {
		this.detailLongitude = detailLongitude;
	}

	// getter/setter 이름 규칙을 표준 Java Bean 규약에 맞게 수정하는 것을 권장합니다.
	// 예: getdetailNo() -> getDetailNo()
	public int getDetailNo() {
		return detailNo;
	}

	public void setDetailNo(int detailNo) {
		this.detailNo = detailNo;
	}

	// 다른 getter/setter들도 일관성을 위해 수정 (기존 코드 호환성을 위해 이름 유지도 가능)
	public int getdetailNo() {
		return detailNo;
	}
	public void setdetailNo(int detailNo) {
		this.detailNo = detailNo;
	}
	public Date getdetailDate() {
		return detailDate;
	}
	public void setdetailDate(Date detailDate) {
		this.detailDate = detailDate;
	}
	public String getdetailRoadAddress() {
		return detailRoadAddress;
	}
	public void setdetailRoadAddress(String detailRoadAddress) {
		this.detailRoadAddress = detailRoadAddress;
	}
	public String getdetailBusinessName() {
		return detailBusinessName;
	}
	public void setdetailBusinessName(String detailBusinessName) {
		this.detailBusinessName = detailBusinessName;
	}
	public String getdetailBusinessEng() {
		return detailBusinessEng;
	}
	public void setdetailBusinessEng(String detailBusinessEng) {
		this.detailBusinessEng = detailBusinessEng;
	}
	public String getdetailDailyTicket() {
		return detailDailyTicket;
	}
	public void setdetailDailyTicket(String detailDailyTicket) {
		this.detailDailyTicket = detailDailyTicket;
	}
	public String getdetailMonthlyTicket() {
		return detailMonthlyTicket;
	}
	public void setdetailMonthlyTicket(String detailMonthlyTicket) {
		this.detailMonthlyTicket = detailMonthlyTicket;
	}
	public String getdetailComment() {
		return detailComment;
	}
	public void setdetailComment(String detailComment) {
		this.detailComment = detailComment;
	}
	public String getdetailServiceProgram() {
		return detailServiceProgram;
	}
	public void setdetailServiceProgram(String detailServiceProgram) {
		this.detailServiceProgram = detailServiceProgram;
	}
	public String getdetailClassification() {
		return detailClassification;
	}
	public void setdetailClassification(String detailClassification) {
		this.detailClassification = detailClassification;
	}
	public String getdetailFreeService() {
		return detailFreeService;
	}
	public void setdetailFreeService(String detailFreeService) {
		this.detailFreeService = detailFreeService;
	}
	public int getdetailMonthlyPrice() {
		return detailMonthlyPrice;
	}
	public void setdetailMonthlyPrice(int detailMonthlyPrice) {
		this.detailMonthlyPrice = detailMonthlyPrice;
	}
	public String getdetailKoClassification() {
		return detailKoClassification;
	}
	public void setdetailKoClassification(String detailKoClassification) {
		this.detailKoClassification = detailKoClassification;
	}
}