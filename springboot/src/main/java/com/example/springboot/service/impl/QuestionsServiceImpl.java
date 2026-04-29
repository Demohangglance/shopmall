package com.example.springboot.service.impl;;

import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.springboot.entity.Questions;
import com.example.springboot.mapper.QuestionsMapper;
import com.example.springboot.service.IQuestionsService;
import org.springframework.stereotype.Service;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

@Service
public class QuestionsServiceImpl extends ServiceImpl<QuestionsMapper, Questions> implements IQuestionsService{

    @Override
    public boolean save(Questions entity) {
        return super.save(entity);
    }

    @Override
    public boolean updateById(Questions entity) {
        return super.updateById(entity);
    }

    @Override
    public boolean removeById(Questions entity) {
        return super.removeById(entity);
    }

    @Override
    public boolean removeBatchByIds(Collection<?> list) {
        return super.removeBatchByIds(list);
    }

    @Override
    public List<Questions> list() {
        return super.list();
    }

    @Override
    public Questions getById(Serializable id) {
        return super.getById(id);
    }

    @Override
    public <E extends IPage<Questions>> E page(E page, Wrapper<Questions> queryWrapper) {
        return super.page(page, queryWrapper);
    }

}
