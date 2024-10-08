package com.isix.easyGym.payform.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import com.isix.easyGym.detail.dto.DetailDTO;
import com.isix.easyGym.member.dto.MemberDTO;
import com.isix.easyGym.payform.dao.PayformDAO;
import com.isix.easyGym.payform.dto.PayformDTO;

@Service("payformService")
public class PayformServiceImpl implements PayformService {

    @Autowired
    private PayformDAO payformDAO;

    @Override
    public List getPayformData(Map payformData) throws DataAccessException {
        List list = new ArrayList();
        MemberDTO memberDTO = payformDAO.selectMemberByNo((int)payformData.get("member"));
        DetailDTO detailDTO = payformDAO.selectDetailByNo((int)payformData.get("detail"));
        list.add(memberDTO);
        list.add(detailDTO);
        return list;
    }

   @Override
   public int buyCheck(int memberNo) throws DataAccessException {
      int payformNo= payformDAO.checkingBuy(memberNo);
      return payformNo;
   }

    @Override
    public int insertPayform(Map payformMap) throws DataAccessException {
        int payformNo = payformDAO.getNewPayformNo();
        payformMap.put("payformNo", payformNo);
        payformDAO.insertPayform(payformMap);
        payformDAO.updateMemberPoints(payformMap);
        return payformNo;
    }

    @Override
    public PayformDTO selectPayform(int payformNo) throws DataAccessException {
        return payformDAO.viewPayform(payformNo);
    }

    @Override
    public int cancelPayform(int payformNo) throws DataAccessException {
        return payformDAO.cancelPayform(payformNo);
    }

    @Override
    public int getPurchaseCount(Map selectMap) throws DataAccessException {
        int purchaseCount = payformDAO.selectPurchaseCount(selectMap);
        return purchaseCount;
    }

    public void refundPoint(Map payformMap) throws DataAccessException {
        payformDAO.refundPoint(payformMap);
    }

   @Override
   public int findpay(Map<String, Object> selectMap) throws DataAccessException {
      int payformNo = payformDAO.selectPayformNo(selectMap);
      return payformNo;
   }


}
