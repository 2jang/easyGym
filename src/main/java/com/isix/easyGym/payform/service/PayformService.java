package com.isix.easyGym.payform.service;

import com.isix.easyGym.payform.dto.PayformDTO;
import org.springframework.dao.DataAccessException;

import java.util.List;
import java.util.Map;

public interface PayformService {
    public List getPayformData(Map payformData) throws DataAccessException;

    public int insertPayform(Map payformMap) throws DataAccessException;

    public PayformDTO selectPayform(int payformNo) throws DataAccessException;

    public int buyCheck(int memberNo) throws DataAccessException;

    public int findpay(Map<String,Object> selectMap) throws DataAccessException;

    public void refundPoint(Map payformMap) throws DataAccessException;

    public int cancelPayform(int payformNo) throws DataAccessException;

    public int getPurchaseCount(Map selectMap) throws DataAccessException;
    }