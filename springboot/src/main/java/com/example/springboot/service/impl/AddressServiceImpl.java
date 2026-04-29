package com.example.springboot.service.impl;;

import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.springboot.entity.Address;
import com.example.springboot.mapper.AddressMapper;
import com.example.springboot.service.IAddressService;
import com.example.springboot.utils.TokenUtils;
import org.springframework.stereotype.Service;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

@Service
public class AddressServiceImpl extends ServiceImpl<AddressMapper, Address> implements IAddressService{

    @Override
    public boolean save(Address entity) {
        return super.save(entity);
    }

    @Override
    public boolean updateById(Address entity) {
        return super.updateById(entity);
    }

    @Override
    public boolean removeById(Address entity) {
        return super.removeById(entity);
    }

    @Override
    public boolean removeBatchByIds(Collection<?> list) {
        return super.removeBatchByIds(list);
    }

    @Override
    public List<Address> list() {
        return super.list(new LambdaQueryWrapper<Address>().eq(Address::getUserid, TokenUtils.getCurrentUser().getId()).orderByDesc(Address::getIsdefault));
    }

    @Override
    public Address getById(Serializable id) {
        return super.getById(id);
    }

    @Override
    public <E extends IPage<Address>> E page(E page, Wrapper<Address> queryWrapper) {
        return super.page(page, queryWrapper);
    }

    @Override
    public void setDefault(Address address) {
        List<Address> list = super.list(new LambdaQueryWrapper<Address>().eq(Address::getUserid, TokenUtils.getCurrentUser().getId()));
        for (Address address1 : list) {
            address1.setIsdefault("否");
            super.updateById(address1);
        }
        // 设置默认地址
        super.updateById(address);
    }

}
