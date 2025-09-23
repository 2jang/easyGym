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

    public int getDetailNo() {
        return detailNo;
    }

    public void setDetailNo(int detailNo) {
        this.detailNo = detailNo;
    }

    public Date getDetailDate() {
        return detailDate;
    }

    public void setDetailDate(Date detailDate) {
        this.detailDate = detailDate;
    }

    public String getDetailRoadAddress() {
        return detailRoadAddress;
    }

    public void setDetailRoadAddress(String detailRoadAddress) {
        this.detailRoadAddress = detailRoadAddress;
    }

    public String getDetailBusinessName() {
        return detailBusinessName;
    }

    public void setDetailBusinessName(String detailBusinessName) {
        this.detailBusinessName = detailBusinessName;
    }

    public String getDetailBusinessEng() {
        return detailBusinessEng;
    }

    public void setDetailBusinessEng(String detailBusinessEng) {
        this.detailBusinessEng = detailBusinessEng;
    }

    public String getDetailDailyTicket() {
        return detailDailyTicket;
    }

    public void setDetailDailyTicket(String detailDailyTicket) {
        this.detailDailyTicket = detailDailyTicket;
    }

    public String getDetailMonthlyTicket() {
        return detailMonthlyTicket;
    }

    public void setDetailMonthlyTicket(String detailMonthlyTicket) {
        this.detailMonthlyTicket = detailMonthlyTicket;
    }

    public String getDetailComment() {
        return detailComment;
    }

    public void setDetailComment(String detailComment) {
        this.detailComment = detailComment;
    }

    public String getDetailServiceProgram() {
        return detailServiceProgram;
    }

    public void setDetailServiceProgram(String detailServiceProgram) {
        this.detailServiceProgram = detailServiceProgram;
    }

    public String getDetailClassification() {
        return detailClassification;
    }

    public void setDetailClassification(String detailClassification) {
        this.detailClassification = detailClassification;
    }

    public String getDetailFreeService() {
        return detailFreeService;
    }

    public void setDetailFreeService(String detailFreeService) {
        this.detailFreeService = detailFreeService;
    }

    public int getDetailMonthlyPrice() {
        return detailMonthlyPrice;
    }

    public void setDetailMonthlyPrice(int detailMonthlyPrice) {
        this.detailMonthlyPrice = detailMonthlyPrice;
    }

    public String getDetailKoClassification() {
        return detailKoClassification;
    }

    public void setDetailKoClassification(String detailKoClassification) {
        this.detailKoClassification = detailKoClassification;
    }
}