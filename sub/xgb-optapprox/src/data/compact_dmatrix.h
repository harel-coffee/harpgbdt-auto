/*!
 * Copyright 2015 by Contributors
 * \file simple_dmatrix.h
 * \brief In-memory version of DMatrix.
 * \author Tianqi Chen
 */
#ifndef XGBOOST_DATA_COMPACT_DMATRIX_H_
#define XGBOOST_DATA_COMPACT_DMATRIX_H_

#include <xgboost/base.h>
#include <xgboost/data.h>
#include <algorithm>
#include <cstring>
#include <vector>

namespace xgboost {
//namespace data {

class EntryCompact2{
    public:
        unsigned int _index;
        unsigned int _binid;

        EntryCompact2(unsigned int index, unsigned int binid):
            _index(index),_binid(binid){}

        inline unsigned int index() const{
            return _index;
        }

        inline unsigned int binid() const{
            return _binid;
        }
};

class EntryCompact{
    public:
        unsigned int _data;
        EntryCompact(unsigned int index, unsigned int binid){
            _data = (binid << 24) | ( index & 0xffffff);
        }

        inline unsigned int index() const{
            return _data & 0xffffff;
        }

        inline unsigned int binid() const{
            return _data >> 24;
        }
};

class DMatrixCompact {
 private:
     std::vector<EntryCompact> data;
     std::vector<size_t> offset;

 public:
  explicit DMatrixCompact(){}

  //initialize
  void Init(const SparsePage& page);

  using Inst = common::Span<EntryCompact const>;

  inline Inst operator[](size_t i) const {
    return {data.data() + offset[i],
            static_cast<Inst::index_type>(offset[i + 1] - offset[i])};
  }

  inline int Size(){
    return offset.size() - 1; 
  }
};
//}  // namespace data
}  // namespace xgboost
#endif  // XGBOOST_DATA_COMPACT_DMATRIX_H_