package com.example.springboot.service.impl;;

import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.springboot.entity.Type;
import com.example.springboot.mapper.TypeMapper;
import com.example.springboot.service.ITypeService;
import org.springframework.stereotype.Service;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

@Service
public class TypeServiceImpl extends ServiceImpl<TypeMapper, Type> implements ITypeService{

    @Override
    public boolean save(Type entity) {
        return super.save(entity);
    }

    @Override
    public boolean updateById(Type entity) {
        return super.updateById(entity);
    }

    @Override
    public boolean removeById(Type entity) {
        return super.removeById(entity);
    }

    @Override
    public boolean removeBatchByIds(Collection<?> list) {
        return super.removeBatchByIds(list);
    }

    @Override
    public List<Type> list() {
        return super.list();
    }

    @Override
    public Type getById(Serializable id) {
        return super.getById(id);
    }

    @Override
    public <E extends IPage<Type>> E page(E page, Wrapper<Type> queryWrapper) {
        return super.page(page, queryWrapper);
    }

}
