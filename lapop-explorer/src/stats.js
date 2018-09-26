import jst from 'jstat';

export const ols = (b, A) => {
  console.log(b)
  console.log(A)
  return jst.models.ols(b, A)
}
